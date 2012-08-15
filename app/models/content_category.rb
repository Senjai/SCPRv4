class ContentCategory < ActiveRecord::Base
  self.table_name =  'contentbase_contentcategory'
  self.primary_key = "id"
  map_content_type_for_django
  
  belongs_to :category
  belongs_to :content, :polymorphic => true
end