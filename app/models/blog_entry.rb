class BlogEntry < ContentBase
  self.table_name =  "blogs_entry"
  
  CONTENT_TYPE = "blogs/entry"
  PRIMARY_ASSET_SCHEME = :blog_asset_scheme
  
  belongs_to :blog
  belongs_to :author, :class_name => "Bio"
  
  scope :published, where(:status => STATUS_LIVE)
  scope :this_week, lambda { where("published_at > ?", Date.today - 7) }
  
  define_index do
    indexes title
    indexes content
    has blog.id, :as => :blog
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has "CRC32(CONCAT('blogs/entry:',blogs_entry.id))", :type => :integer, :as => :obj_key
    has "(blogs_entry.blog_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
    where "blogs_entry.status = #{STATUS_LIVE} and blogs_blog.is_active = 1"
  end
    
  #----------
  
  def byline_elements
    []
  end
  
  def headline
    self.title
  end
  
  def body
    return self.content
  end
    
  def previous
    self.class.published.first(:conditions => ["published_at < ? and blog_id = ?", self.published_at, self.blog_id], :limit => 1, :order => "published_at desc")
  end

  def next
    self.class.published.first(:conditions => ["published_at > ? and blog_id = ?", self.published_at, self.blog_id], :limit => 1, :order => "published_at asc")
  end
  
  #----------
  
  def link_path
    Rails.application.routes.url_helpers.blog_entry_path(
      :blog => self.blog.slug,
      :year => self.published_at.year, 
      :month => self.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :id => self.id,
      :slug => self.slug,
      :trailing_slash => true
    )
    
  end
end