class Blog < ActiveRecord::Base
  set_table_name 'blogs_blog'
  
  has_many :entries, :class_name => "BlogEntry"
  
  scope :active, where(:is_active => true)
end