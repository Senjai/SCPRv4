class BlogCategory < ActiveRecord::Base
  self.table_name = "blogs_blogcategory"
  belongs_to :blog
  
  validates :title, presence: true
  validates :slug, presence: true
end
