class ContentCategory < ActiveRecord::Base
  self.table_name =  'contentbase_contentcategory'

  map_content_type_for_django
  belongs_to :content, polymorphic: true
  belongs_to :category
end
