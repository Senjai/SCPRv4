class TaggedContent < ActiveRecord::Base
  self.table_name = "taggit_taggeditem"
  
  map_content_type_for_django
  belongs_to :content, polymorphic: true
  belongs_to :tag
end
