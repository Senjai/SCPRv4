class Audio < ActiveRecord::Base
  self.table_name  = 'media_audio'
  self.primary_key = "id"
  
  AUDIO_ROOT   = File.join(Rails.application.config.scpr.media_url, "audio")
  PODCAST_ROOT = File.join(Rails.application.config.scpr.media_url, "podcasts")
  
  STORE_DIRS = {
    :enco    => "features",  # The ENCO id and date were given
    :upload  => "upload",    # The audio was uploaded via the CMS
    :direct  => "",          # A path to an audio file was given
    :program => ""           # Automatic via cron, no user interaction
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
      File.join(AUDIO_ROOT, self.path) if self.live?
    end
  end

  #------------
  # The full URL to the live podcast audio,
  # eg. http://media.scpr.org/podcasts/airtalk/20120928_airtalk.mp3
  def podcast_url
    @podcast_url ||= begin
      File.join(PODCAST_ROOT, self.path) if self.live?
    end
  end
  
  
  #------------
  # Set audio type based on conditions
  # And set some file info that Carrierwave doesn't store
  def set_file_info
    if self.content.is_a?(ShowEpisode) && self.live?
      self.type       = "Audio::EpisodeAudio"
      self.store_dir  = self.content.show.audio_dir
      self.filename   = self.mp3.file.filename
      
    elsif self.live?
      self.type       = "Audio::UploadedAudio"
      self.store_dir  = "#{STORE_DIRS[:upload]}/#{Time.now.strftime("%Y/%m/%d")}"
      self.filename   = self.mp3.file.filename
      
    elsif self.enco_number.present? && self.enco_date.present?
      self.type       = "Audio::EncoAudio"
      self.store_dir  = STORE_DIRS[:enco]
      date            = Chronic.parse(self.enco_date).strftime("%Y%m%d")
      self.filename   = "#{date}_features#{self.enco_number}.mp3"
      
    elsif self.mp3_path.present?
      self.type      = "Audio::DirectAudio"
      path           = self.mp3_path.split("/")
      self.filename  = path.pop
      self.store_dir = path.join("/")
    
    end
  end
  
  
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
  # Queue the computation jobs
  def async_compute_file_info
    Resque.enqueue(ComputeFileInfoJob, self)
  end
  
  #------------
  # Resque
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
  # Audio Types
  # These classes can be used to have different behavior
  # for different types of audio.
  # Hopefully that won't be necessary, though.
  #
  # EncoAudio is given enco_number and enco_date
  class EncoAudio < Audio
  end
  
  # EpisodeAudio is created automatically
  # by a cron job when the content is a ShowEpisode
  class EpisodeAudio < Audio
  end
  
  # DirectAudio is given an arbitrary path to an mp3
  class DirectAudio < Audio
  end
  
  # UploadedAudio is uploaded via the CMS
  class UploadedAudio < Audio
  end
end
