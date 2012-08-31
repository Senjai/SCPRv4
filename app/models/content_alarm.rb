class ContentAlarm < ActiveRecord::Base
  self.table_name = "contentbase_contentalarm"
  
  default_scope where("content_type is not null")
  
  map_content_type_for_django
  belongs_to :content, polymorphic: true
end
