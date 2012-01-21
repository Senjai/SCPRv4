class Link < ActiveRecord::Base
  self.table_name =  'rails_media_link'
  
  belongs_to :content, :polymorphic => true
end