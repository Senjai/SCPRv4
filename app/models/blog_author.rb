##
# BlogAuthor
# Join class between Blog and Bio
#
class BlogAuthor < ActiveRecord::Base
  self.table_name = "blogs_blogauthor"
  
  belongs_to :blog, touch: true
  belongs_to :author, class_name: "Bio"
end
