class Blog < ActiveRecord::Base
  self.table_name =  'blogs_blog'
  
  has_many :entries, :order => 'published_at desc', class_name: "BlogEntry"
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
  
  def self.cache_remote_entries
    success = []
    self.remote.each do |blog|
      if blog.feed_url.present? # No reason to even try if the feed_url is blank
        if feed = Feedzirra::Feed.fetch_and_parse(blog.feed_url) and !feed.is_a?(Fixnum) # Feedzirra returns the response code as a FixNum if something goes wrong.
          success.push blog if Rails.cache.write(
            "remote_blog:#{blog.slug}", 
             ActionView::Base.new(ActionController::Base.view_paths, {}).render(partial: "blogs/cached/remote_blog_entry", collection: feed.entries.first(1), as: :entry)
          )
        end
      end
    end # remote.each
    return success
  end
end
