class Audio < ActiveRecord::Base
  self.table_name =  'media_audio'
  self.primary_key = "id"
  
  AUDIO_ROOT   = "http://media.scpr.org"
  PODCAST_ROOT = "http://media.scpr.org/podcasts"
  
  STATUS_NONE = nil
  STATUS_WAIT = 1
  STATUS_LIVE = 2
  
  STATUS_TEXT = {
    STATUS_NONE => "None",
    STATUS_WAIT => "Awaiting ENCO",
    STATUS_LIVE => "Live"
  }
  

  #------------
  # Association
  map_content_type_for_django
  belongs_to :content, polymorphic: true
  mount_uploader :mp3, AudioUploader
  

  #------------
  # Callbacks
  after_save :compute_duration, if: -> { self.mp3_path.present? }
  after_save :compute_size, if: -> { self.mp3_path.present? }

  
  #------------
  # Validation
  validates :enco_date, presence: true, if: -> { self.enco_number.present? }
  

  #------------
  # Scopes
  scope :available,     where("mp3 is not null and mp3 != ''")
  scope :with_enco,     where("enco_number is not null and enco_number != 0 and enco_date is not null")
  scope :awaiting_enco, with_enco.where("mp3 is null or mp3 = ''")

  #------------
  
  def path_elements
    self.mp3.split "/"
  end

  #------------
  
  def url
    if mp3.present?
      "#{AUDIO_ROOT}/#{self.mp3}"
    else
      nil
    end
  end
  
  #------------
  
  def podcast_url
    if mp3.present?
      # This assumes that the audio will start with `audio/`
      "#{PODCAST_ROOT}/#{self.path_elements.drop(1).join("/")}"
    else
      nil
    end
  end

  #------------
  
  def mp3_path
    if mp3.present?
      [Rails.application.config.scpr.media_root,self.mp3].join('/')
    else
      nil
    end
  end

  #------------
  
  def compute_duration
    if File.exists?(self.mp3_path)
      begin
        Mp3Info.open(self.mp3_path) do |mp3|
          self.duration = mp3.length
          self.save
        end
      rescue
        Audio.logger.info "Failed to parse file: #{self.content.class}/#{self.content.id} -- #{self.mp3_path}"
      end
    else
      Audio.logger.info "Not Found: #{self.content.class}/#{self.content.id} -- #{self.mp3_path}"
    end
  end

  #------------
  
  def compute_size
    if File.exists?(self.mp3_path)
      File.open(self.mp3_path) do |f|
        self.size = f.size
      end
    else
      Audio.logger.info "Not Found: #{self.content.class}/#{self.content.id} -- #{self.mp3_path}"
      audio.size = 0
    end
    
    audio.save
  end
  
  #------------

  def status_text
    STATUS_TEXT[self.status]
  end

  #------------
  
  def status
    if mp3.present?
      STATUS_LIVE
    elsif enco_number.present? && enco_date.present?
      STATUS_WAIT
    else
      STATUS_NONE
    end
  end
  
  def self.logger
    Logger.new("#{Rails.root}/log/audio-tasks.log")
  end
  
  #------------
  
  class ComputeFileInfoJob
    @wueue = Rails.application.config.scpr.resque_queue
    
    def self.perform(audio)
      audio.compute_duration
      audio.compute_size
    end
  end
end
