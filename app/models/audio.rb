class Audio < ActiveRecord::Base
  self.table_name =  'rails_media_audio'
  self.primary_key = :id
  
  belongs_to :content, :polymorphic => true

  default_scope where("mp3 is not null and mp3 != ''")
  scope :with_enco, where("enco_number is not null and enco_date is not null")
  
  def url
    "http://media.scpr.org/#{self.mp3}"
  end
  
  def mp3_path
    Rails.application.config.scpr.media_root ? [Rails.application.config.scpr.media_root,self.mp3].join('/') : false
  end
  
end