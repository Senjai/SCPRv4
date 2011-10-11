class UploadedAudio < ActiveRecord::Base
  set_table_name 'rails_media_uploadedaudio'
  
  belongs_to :content, :polymorphic => true
end