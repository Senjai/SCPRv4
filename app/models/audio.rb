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
  self.table_name = "media_audio"
  logs_as_task
  
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
  belongs_to :content, polymorphic: true, touch: true
  mount_uploader :mp3, AudioUploader
  

  #------------
  # Validation
  validate :enco_info_is_present_together
  validate :audio_source_is_provided

  validate :path_is_unique, if: -> { self.new_record? }

  # Don't run this for development, 
  # so that we can still save objects even though the file won't exist on dev machines. 
  validate :mp3_exists, unless: -> { self.new_record? || Rails.env == "development" }
  
  def enco_info_is_present_together
    if self.enco_number.blank? ^ self.enco_date.blank?
      errors.add(:base, "Enco number and Enco date must both be present for ENCO audio")
      # Just so the form is aware that enco_number and enco_date are involved
      errors.add(:enco_number, "")
      errors.add(:enco_date, "")
    end
  end
  
  #------------  
  # Check if an audio source was given.
  # For the mp3 column, Carrierwave checks that
  # the file actually exists on the filesystem
  # (in `CarrierWave::Uploader::Proxy#blank?`), so
  # we will just check that the column is filled here.
  # If it's filled in but the audio doesn't exist,
  # #mp3_exists will catch that with a more helpful
  # error message.
  def audio_source_is_provided
    if self.mp3_path.blank? && self.mp3.file.nil? && self.enco_number.blank? && self.enco_date.blank?
      self.errors.add(:base, "Audio must have a source (upload, enco, or path)")
    end
  end
  
  # If the column is filled in, but the file doesn't exist, invalid
  def mp3_exists
    # Can't use `present?` on mp3.file, because CarrierWave defines an `empty?` method on SanitizedFile    
    if !self.mp3.file.nil? && self.mp3.blank?
      self.errors.add(:mp3, "doesn't exist on the filesystem (#{self.full_path}). Perhaps it was deleted?")
    end
  end
  
  # Make sure the audio file has a unique name.
  def path_is_unique
    return true if self.mp3.file.blank?

    # Guess what the audio path will be before it's actually saved there.
    # This is predictable for uploaded audio.
    # This could potentially fail if someone was uploading audio at exactly
    # midnight and some audio already existed for the next day.
    path = File.join(
      AUDIO_PATH_ROOT,
      UploadedAudio.store_dir,
      self.mp3.filename
    )
    
    if File.exist?(path)
      self.errors.add(:mp3, "A file with that name already exists; " \
        "please rename your local audio file and try again. " \
        "If you are trying to replace the audio file, first delete the " \
        "old audio.")
    end
  end

  #------------
  # Callbacks
  before_save   :set_type, if: -> { self.type.blank? }
  before_save   :set_file_info, if: -> { self.filename.blank? || self.store_dir.blank? }
  before_save   :nilify_blanks
  after_save    :async_compute_file_info, if: -> { self.mp3.present? && (self.size.blank? || self.duration.blank?) }
  
  #------------
  # Nilify these attributes just to keep everything consistent in the DB
  # This is only applicable to text values that are coming from the form
  def nilify_blanks
    [:enco_number, :mp3_path].each do |attribute|
      if self[attribute] == ""
        self[attribute] = nil
      end
    end
  end


  #------------
  # Scopes
  scope :available,      -> { where("mp3 is not null") }
  scope :awaiting_audio, -> { where("mp3 is null") }

  
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
  # The URL path, i.e. the path without "audio/"
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
  # Compute duration and size, and save the object
  def compute_file_info!
    if self.mp3.present?
      self.compute_duration
      self.compute_size
      self.save!
      self
    end
  end
  
  #------------
  #------------
  # Queue the computation jobs
  def async_compute_file_info
    Resque.enqueue(Audio::ComputeFileInfoJob, self.id)
  end

  #------------
  # Enqueue the audio sync
  def self.enqueue_sync
    Resque.enqueue(Audio::SyncAudioJob, self.name)
  end
    
  # Proxy to AudioSync::enqueue_all
  def self.enqueue_all
    Audio::Sync.enqueue_all
  end
  
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
end
