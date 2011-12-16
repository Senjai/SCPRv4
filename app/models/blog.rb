class Blog < ActiveRecord::Base
  set_table_name 'blogs_blog'
  
  has_many :entries, :order => 'published_at desc', :class_name => "BlogEntry"
  
  scope :active, where(:is_active => true)
end