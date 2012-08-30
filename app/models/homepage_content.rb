class HomepageContent < ActiveRecord::Base
  self.table_name =  "layout_homepagecontent"

  map_content_type_for_django
  belongs_to :content, polymorphic: true    
  belongs_to :homepage
end
