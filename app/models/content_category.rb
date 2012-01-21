class ContentCategory < ActiveRecord::Base
  self.table_name =  'rails_contentbase_contentcategory'
  
  belongs_to :category
  belongs_to :content, :polymorphic => true
end