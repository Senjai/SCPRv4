class HomepageContent < ActiveRecord::Base
  include Concern::Methods::ContentSimpleJsonMethods
  self.table_name =  "layout_homepagecontent"

  belongs_to :content, polymorphic: true
  belongs_to :homepage
end
