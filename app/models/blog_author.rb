class BlogAuthor < ActiveRecord::Base
  self.table_name = "blogs_blog_authors"
  
  belongs_to :blog
  belongs_to :author, class_name: "Bio", foreign_key: "bio_id"
end