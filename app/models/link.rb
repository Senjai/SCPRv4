class Link < ActiveRecord::Base
  set_table_name 'rails_media_link'
  
  belongs_to :content, :polymorphic => true
end