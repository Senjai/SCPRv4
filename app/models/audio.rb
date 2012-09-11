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
end
