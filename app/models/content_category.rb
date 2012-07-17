class ContentCategory < ActiveRecord::Base
  self.table_name =  'rails_contentbase_contentcategory'
  self.primary_key = "id"
  
  belongs_to :category
  belongs_to :content, :polymorphic => true
end