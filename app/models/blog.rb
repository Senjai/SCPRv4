class Blog < ActiveRecord::Base
  self.table_name =  'blogs_blog'
  
  has_many :entries, :order => 'published_at desc', :class_name => "BlogEntry"
  
  has_many :tags, :through => :entries
  
  scope :active, where(:is_active => true)
end