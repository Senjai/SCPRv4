class Blog < ActiveRecord::Base
  self.table_name =  'blogs_blog'
  
  has_many :blog_entries, :order => 'published_at desc'
  has_many :tags, :through => :blog_entries
  
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
  
  def feed
    feed = Feedzirra::Feed.fetch_and_parse feed_url
    return feed == 0 ? false : feed
  end
  
  def entries
    self.is_remote ? remote_entries : blog_entries.published
  end
  
  def all_entries # Because the "entries" method only returns published entries
    self.is_remote ? remote_entries : blog_entries
  end
  
  def remote_entries
    feed.entries
  end
end