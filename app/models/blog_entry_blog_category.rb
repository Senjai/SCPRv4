class BlogEntryBlogCategory < ActiveRecord::Base
  self.table_name = "blogs_entryblogcategory"
  
  belongs_to :blog_entry, foreign_key: "entry_id"
  belongs_to :blog_category
end
