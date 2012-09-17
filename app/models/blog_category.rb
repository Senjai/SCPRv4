##
# BlogCategory
# Blog-specific categories
#
class BlogCategory < ActiveRecord::Base
  self.table_name = "blogs_blogcategory"

  #--------------
  # Association
  belongs_to :blog
  has_many :blog_entry_blog_categories
  has_many :blog_entries, through: :blog_entry_blog_categories, dependent: :destroy
  
  #--------------
  # Validation
  validates :title, presence: true
  validates :slug, presence: true
end
