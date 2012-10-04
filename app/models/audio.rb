##
# Audio
#
# :filename and :store_dir should be present for
# every record, even if it's not live.
#
# :mp3 should be present for live audio, but can be null otherwise
# :enco_number, :enco_date, and :mp3_path are STI
# columns that can be null depending on audio source
#
class Audio < ActiveRecord::Base
  self.table_name  = 'media_audio'
  self.primary_key = "id"
  
  # Server path root - /home/media/kpcc/audio
  AUDIO_PATH_ROOT = File.join(Rails.application.config.scpr.media_root, "audio")
  
  # Public URL root - http://media.scpr.org/audio
  AUDIO_URL_ROOT   = File.join(Rails.application.config.scpr.media_url, "audio")
  PODCAST_URL_ROOT = File.join(Rails.application.config.scpr.media_url, "podcasts")
  
  STORE_DIRS = {
    :enco    => "features",  # The ENCO id and date were given
    :upload  => "upload",    # The audio was uploaded via the CMS
    :direct  => "",          # A path to an audio file was given
    :program => ""           # Automatic via cron, no user interaction
  }
  
  # Filename regular expressions
  FILENAMES = {
    :program => %r{(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})_(?<slug>\w+)\.mp3},             # 20121001_mbrand.mp3
    :enco    => %r{(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})_features(?<enco_id>\d{4})\.mp3} # 20121001_features1809.mp3
  }
  
  STATUS_NONE = nil
  STATUS_WAIT = 1
  STATUS_LIVE = 2
  
  STATUS_TEXT = {
    STATUS_NONE => "None",
    STATUS_WAIT => "Awaiting Audio",
    STATUS_LIVE => "Live"
  }
  
  
  #------------
  # Association
  map_content_type_for_django
  belongs_to :content, polymorphic: true
  mount_uploader :mp3, AudioUploader
  

  #------------
  # Callbacks
  before_create :set_type, if: -> { self.type.blank? }
  before_create :set_file_info
  
  after_save    :async_compute_file_info, if: -> { self.mp3.present? && (self.size.blank? || self.duration.blank?) }

  
  #------------
  # Validation
  validates :enco_date,   presence: true, if: -> { self.enco_number.present? }
  validates :enco_number, presence: true, if: -> { self.enco_date.present? }
  validate  :audio_source_is_provided
  
  def audio_source_is_provided
    if self.mp3_path.blank? && self.mp3.blank? && self.enco_number.blank? && self.enco_date.blank?
      self.errors.add(:base, "Audio must have a source (upload, enco, or path)")
    end
  end


  #------------
  # Scopes
  scope :available,      -> { where("mp3 is not null and mp3 != ''") }
  scope :awaiting_audio, -> { where("mp3 is null or mp3 = ''") }


  #------------
  #------------
  
  #------------
  # Enqueue the sync task for any subclasses that need it
  def self.sync!
    [Audio::ProgramAudio, Audio::DirectAudio, Audio::EncoAudio].each do |klass|
      Resque.enqueue(Audio::SyncAudioJob, klass)
    end
  end

  
  #------------
  #------------

  def status_text
    STATUS_TEXT[self.status]
  end

  #------------
  
  def status
    @status ||= begin
      if mp3.present?
        STATUS_LIVE
      elsif self.enco_number.present? || self.mp3_path.present?
        STATUS_WAIT
      else
        STATUS_NONE
      end
    end
  end

  #------------
  
  def live?
    self.status == STATUS_LIVE
  end

  #------------
  
  def awaiting?
    self.status == STATUS_WAIT
  end
  
  
  #------------
  # The URL path, 
  # eg. /upload/2012/10/01/your_sweet_audio.mp3
  def path
    @path ||= File.join self.store_dir, self.filename
  end

  #------------
  # The server path, 
  # eg. /home/kpcc/media/audio/features/20121001_features999.mp3
  def full_path
    @full_path ||= File.join Rails.application.config.scpr.media_root, "audio", self.path
  end

  #------------
  # The full URL to the live audio,
  # eg. http://media.scpr.org/audio/upload/2012/10/01/your_sweet_audio.mp3
  def url
    @url ||= begin
      File.join(AUDIO_URL_ROOT, self.path) if self.live?
    end
  end

  #------------
  # The full URL to the live podcast audio,
  # eg. http://media.scpr.org/podcasts/airtalk/20120928_airtalk.mp3
  def podcast_url
    @podcast_url ||= begin
      File.join(PODCAST_URL_ROOT, self.path) if self.live?
    end
  end
  

  #------------
  #------------
  # Set file info, using each subclass's methods
  # for generating store_dir and filename
  def set_file_info
    if self.type.present?
      self.filename  = self.type.constantize.filename(self)
      self.store_dir = self.type.constantize.store_dir(self)
    end
  end
  
  
  #------------  
  #------------
  # Compute duration via Mp3Info
  # Set to 0 if something goes wrong
  # so it's not considered "blank"
  def compute_duration
    return false if self.mp3.blank?
    
    Mp3Info.open(self.mp3.path) do |file|
      self.duration = file.length
    end

    self.duration ||= 0
  end
  
  #------------
  # Compute the size via Carrierwave
  # Set a value to 0 if something goes wrong
  # So that size won't be "blank"
  def compute_size
    return false if self.mp3.blank?
    self.size = self.mp3.file.size # Carrierwave sets this to 0 if it can't compute it
  end
  
  
  #------------  
  #------------
  # Queue the computation jobs
  def async_compute_file_info
    Resque.enqueue(ComputeFileInfoJob, self)
  end

  #------------
  # Enqueue the audio sync
  # Call from cronjob: `rails r "Audio::EncoAudio.enqueue_sync"`
  def self.enqueue_sync
    Resque.enqueue(SyncAudioJob, self)
  end
  
  
  #------------  
  #------------
  # Resque Job classes
  # TODO Move these into a separate file
  class ComputeFileInfoJob
    @queue = Rails.application.config.scpr.resque_queue
    
    def self.perform(audio)
      audio.compute_duration
      audio.compute_size
      
      # If anything has thrown an error,
      # then save won't get called here, 
      # which is good.
      audio.save
    end
  end
  
  #------------
  
  class SyncAudioJob
    @queue = "#{Rails.application.config.scpr.requeue_queue}:syncaudio"
    
    def self.perform(klass)
      klass.sync!
    end
  end
  
  
  #------------  
  #------------
  # Audio Types
  # These classes can be used to have different behavior
  # for different types of audio.
  # TODO Move these into their own files
  #
  # EncoAudio is given enco_number and enco_date
  class EncoAudio < Audio
    #------------
    # Sync ENCO audio on the server 
    # with the database    
    def self.store_dir(audio)
      STORE_DIRS[:enco]
    end
    
    def self.filename(audio)
      date = audio.enco_date.strftime("%Y%m%d")
      "#{date}_features#{audio.enco_number}.mp3"
    end
    
    #------------

    def self.sync!
      self.awaiting_audio.each do |audio|
        if File.exists? audio.full_path
          audio.mp3 = File.open(audio.full_path)
          audio.save!          
        end
      end
    end
  end


  #------------  
  # ProgramAudio is created automatically
  # when the file appears on the filesystem
  # It belongs to a ShowEpisode or ShowSegment
  # for a KpccProgram
  class ProgramAudio < Audio
    before_create :set_description_to_episode_headline, if: -> { self.description.blank? }
    
    def set_description_to_episode_headline
      self.description = self.content.headline
    end

    #------------
    
    def self.store_dir(audio)
      audio.content.show.audio_dir
    end
    
    def self.filename(audio)
      audio.mp3.file.filename
    end


    #------------
    
    def self.sync!
      # Setup a hash to search so we only have to
      # perform one query to check for existance
      existing = {}
      Audio.all.map { |a| existing[a.filename] = true }
      
      # Each KpccProgram with episodes and which can sync audio
      KpccProgram.can_sync_audio.each do |program|
        absolute_directory_path = File.join(AUDIO_PATH_ROOT, program.audio_dir)
        
        # Each file in this program's audio directory
        Dir[absolute_directory_path].each do |file|
          absolute_mp3_path = File.join(absolute_directory_path, file)
          
          # Move on if:
          # 1. File already exists (program audio only needs to exist once in the DB)
          next if existing[file]
          
          # 2. The filename doesn't match our regex (won't be able to get date)
          match = file.match(FILENAMES[:program])
          next if !match
          
          # 3. The file is too old -
          #    If the file was uploaded more than 14 days ago
          #    and still hasn't been matched, then something's wrong.
          #    Maybe the date is incorrect? Either way, at this point
          #    it's too old to keep trying. They can upload the audio
          #    manually if they need to.
          file_date = File.mtime(absolute_mp3_path)
          next if file_date < 14.days.ago

          # Get the date for this episode/segment based on the filename,
          # find that episode/segment, and create the audio / association
          # if the content for that date exists.
          date = Time.new(match[:year], match[:month], match[:day])
          
          if program.display_episodes?
            content = program.episodes.where(air_date: date).first
          else
            content = program.segments.where(published_at: date..date.end_of_day).first
          end
          
          if content
            audio = self.new(content: content, mp3: File.open(absolute_mp3_path))
            audio.save
            content.save # to expire cache
          end
        end
      end
    end
  end
  
  
  #------------
  # DirectAudio is given an arbitrary path to an mp3
  class DirectAudio < Audio
    def self.store_dir(audio)
      path = Pathname.new(audio.mp3_path)
      path.split.first.to_s
    end
    
    def self.filename(audio)
      path = Pathname.new(audio.mp3_path)
      path.split.last.to_s
    end
    
    #------------
    
    def self.sync!
      raise NotImplementedError, "(#{self})"
    end
  end
  
  
  #------------
  # UploadedAudio is uploaded via the CMS
  # Doesn't need to be synced, so no ::sync! method
  class UploadedAudio < Audio
    def self.store_dir(audio)
      "#{STORE_DIRS[:upload]}/#{Time.now.strftime("%Y/%m/%d")}"
    end
    
    def self.filename(audio)
      audio.mp3.file.filename
    end
  end

  
  #------------  
  #------------  
  
  private

    #------------
    # Set audio type based on conditions
    # This only gets run if self.type is blank,
    # which won't be true for ProgramAudio, since
    # it gets created through the subclass,
    # so if we're here and the mp3 is present,
    # we can safely assume it's uploaded audio
    def set_type
      if self.live?
        self.type = "Audio::UploadedAudio"
      
      elsif self.enco_number.present? && self.enco_date.present?
        self.type = "Audio::EncoAudio"
      
      elsif self.mp3_path.present?
        self.type = "Audio::DirectAudio"
      
      end
    end
  #
end
