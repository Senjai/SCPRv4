class EncoAudio < ActiveRecord::Base
  self.table_name =  'media_encoaudio'
  
  def mp3_path
    Rails.application.config.scpr.media_root ? self.url.sub("http://media.scpr.org",Rails.application.config.scpr.media_root) : false
  end
  
end