##
# BlogCategory
# Blog-specific categories
#
class BlogCategory < ActiveRecord::Base
  self.table_name = "blogs_blogcategory"

  administrate do
    define_list do
      per_page = :all
      column :blog
      column :title
      column :slug
    end
  end
      
  #--------------
  # Association
  belongs_to :blog, touch: true
  has_many :blog_entry_blog_categories
  has_many :blog_entries, through: :blog_entry_blog_categories, dependent: :destroy
  
  #--------------
  # Validation
  validates :title, presence: true
  validates :slug, presence: true
end
