class UploadedAudio < ActiveRecord::Base
  self.table_name =  'rails_media_uploadedaudio'
  self.primary_key = :id
  
  belongs_to :content, :polymorphic => true
  
  def url
    "http://media.scpr.org/#{self.mp3_file}"
  end
  
  def mp3_path
    Rails.application.config.scpr.media_root ? [Rails.application.config.scpr.media_root,self.mp3_file].join('/') : false
  end
  
end