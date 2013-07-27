##
# Audio
#
# :filename and :store_dir should be present for
# every record, even if it's not live.
#
# :mp3 should be present for live audio, but can be null otherwise
# :enco_number, :enco_date, and :external_url are STI
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
  validate :audio_source_is_provided
  validate :enco_info_is_present_together

  validate :path_is_unique, if: -> {
    self.new_record? && self.type == "Audio::UploadedAudio"
  }

  # Don't run this for development, so that we can still save objects 
  # even though the file won't exist on dev machines. 
  validate :mp3_file_exists, unless: -> {
    self.new_record? || Rails.env == "development"
  }

  #------------
  # Callbacks

  # It's important to set the type before validation, 
  # so that we can run type-specific validation.
  before_validation :set_type, if: -> { self.type.blank? }

  before_save :set_default_status

  after_save :async_compute_file_info, if: -> {
    self.mp3.present? && (self.size.blank? || self.duration.blank?)
  }


  #------------
  # Scopes
  scope :available,      -> { where(status: STATUS_LIVE) }
  scope :awaiting_audio, -> { where(status: STATUS_WAIT) }



  class << self
    def enqueue_all
      [ProgramAudio, EncoAudio].each(&:enqueue_sync)
    end

    # Enqueue the audio sync
    def enqueue_sync
      Resque.enqueue(Audio::SyncAudioJob, self.name)
    end
  end



  def status_text
    STATUS_TEXT[self.status]
  end

  def live?
    self.status == STATUS_LIVE
  end



  # The following group of methods are necessary in case we need
  # some of this information before the object has been typecast
  # by rails (when pulling it out of the database).
  def path
    typecast_clone.path
  end

  def full_path
    typecast_clone.full_path
  end

  def url
    typecast_clone.url
  end

  def podcast_url
    typecast_clone.podcast_url
  end

  def filename
    if self.mp3.present?
      self.mp3.filename
    else
      typecast_clone.filename
    end
  end

  def store_dir
    typecast_clone.store_dir
  end



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


  # Compute the size via Carrierwave
  # Set a value to 0 if something goes wrong
  # So that size won't be "blank"
  def compute_size
    return false if self.mp3.blank?
    self.size = self.mp3.file.size # Carrierwave sets this to 0 if it can't compute it
  end


  # Compute duration and size, and save the object
  def compute_file_info!
    if self.mp3.present?
      self.compute_duration
      self.compute_size
      self.save!
      self
    end
  end


  # Queue the computation jobs
  def async_compute_file_info
    Resque.enqueue(Audio::ComputeFileInfoJob, self.id)
  end


  def type_class
    self.type.constantize
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
    if self.mp3.present?
      self.type = "Audio::UploadedAudio"

    elsif self.enco_number.present? && self.enco_date.present?
      self.type = "Audio::EncoAudio"

    elsif self.external_url.present?
      self.type = "Audio::DirectAudio"

    end
  end



  def enco_info_is_present_together
    if self.enco_number.blank? ^ self.enco_date.blank?
      errors.add(:base,
        "Enco number and Enco date must both be present for ENCO audio")
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
    if self.external_url.blank? &&
    self.mp3.file.nil? &&
    self.enco_number.blank? &&
    self.enco_date.blank?
      self.errors.add(:base,
        "Audio must have a source (upload, enco, or URL)")
    end
  end

  # If the column is filled in, but the file doesn't exist, invalid
  def mp3_file_exists
    # Can't use `present?` on mp3.file, because CarrierWave 
    # defines an `empty?` method on SanitizedFile
    if !self.mp3.file.nil? && self.mp3.blank?
      self.errors.add(:mp3,
        "doesn't exist on the filesystem (#{self.full_path}). " \
        "Perhaps it was deleted?")
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
      self.store_dir,
      self.filename
    )

    if File.exist?(path)
      self.errors.add(:mp3, "A file with that name already exists; " \
        "please rename your local audio file and try again. " \
        "If you are trying to replace the audio file, first delete the " \
        "old audio.")
    end
  end


  # For uploaded, direct, and program audio, when it gets created
  # we can immediately assume that it's live.
  # For ENCO audio, when it gets created we set it to "awaiting",
  # and its status will get bumped to Live when it gets synced.
  def set_default_status
    self.status = self.type_class.default_status
  end

  def typecast_clone
    if self.class.name != self.type
      write_attribute(:mp3, self.mp3.filename)
      self.becomes(self.type_class)
    else
      self
    end
  end
end
