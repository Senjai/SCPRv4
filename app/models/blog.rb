class Blog < ActiveRecord::Base
  self.table_name =  'blogs_blog'
  
  has_many :entries, :order => 'published_at desc', :class_name => "BlogEntry"
  has_many :tags, :through => :entries
  
  scope :active, where(:is_active => true)
  scope :is_news, where(:is_news => true)
  scope :is_not_news, where(:is_news => false)
  scope :local, where(is_remote: false)
  scope :remote, where(is_remote: true)

  def to_param
    slug
  end
  
  def teaser
    _teaser
  end
end