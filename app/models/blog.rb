class Blog < ActiveRecord::Base
  self.table_name =  'blogs_blog'
  
  # -------------------
  # Administration
  administrate
  self.list_order = "is_active desc, name"  
  self.list_fields = [
    ['name'],
    ['slug'],
    ['teaser',    title: "Tagline"],
    ['is_active', title: "Active?",   display_helper: :display_boolean]
  ]
  
  # -------------------
  # Validations
  validates_presence_of :name, :slug
  
  # -------------------
  # Associations
  has_many :entries, :order => 'published_at desc', class_name: "BlogEntry"
  has_many :tags, :through => :entries
  belongs_to :missed_it_bucket
  has_many :authors, through: :blog_authors, order: "position"
  has_many :blog_authors
  
  # -------------------
  # Scopes
  scope :active, where(:is_active => true)
  scope :is_news, where(:is_news => true)
  scope :is_not_news, where(:is_news => false)
  scope :local, where(is_remote: false)
  scope :remote, where(is_remote: true)
  
  def teaser
    self._teaser
  end
  
  def teaser=(txt)
    self._teaser = txt
  end
  
  def self.cache_remote_entries
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    class << view # So the partial can use the smart_date_js helper
      include ApplicationHelper
    end
    
    success = []
    self.remote.each do |blog|
      if blog.feed_url.present? # No reason to even try if the feed_url is blank
        if feed = Feedzirra::Feed.fetch_and_parse(blog.feed_url) and !feed.is_a?(Fixnum) # Feedzirra returns the response code as a FixNum if something goes wrong.
          success.push blog if Rails.cache.write(
            "remote_blog:#{blog.slug}", 
             view.render(partial: "blogs/cached/remote_blog_entry", collection: feed.entries.first(1), as: :entry)
          )
        end
      end
    end # remote.each
    return success
  end
end
