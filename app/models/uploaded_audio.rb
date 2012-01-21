class UploadedAudio < ActiveRecord::Base
  self.table_name =  'rails_media_uploadedaudio'
  
  belongs_to :content, :polymorphic => true
  
  def url
    "http://media.scpr.org/#{self.mp3_file}"
  end
end