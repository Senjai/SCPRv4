class BlogEntry < ContentBase
  set_table_name "blogs_entry"
  
  CONTENT_TYPE = "blogs/entry"
  
  belongs_to :blog
  belongs_to :author, :class_name => "Bio"
  
  scope :published, where(:status => STATUS_LIVE)
  
  define_index do
    indexes title
    indexes blog
    has category.id, :as => :category
    has published_at
    where "status = #{STATUS_LIVE}"
  end
  
    
  #----------
  
  def canFeature?
    self.blog_asset_scheme == "slideshow" ? true : false
  end
  
  #----------
  
  def byline_elements
    []
  end
  
  def headline
    self.title
  end
  
  def lede(l=240)
    lede = self.content
    if lede.length > l
      lede = /^(.{#{l}}\w*)\W/.match(lede)
      
      if lede
        lede = "#{lede[1]}..."
      else
        lede = self.content
      end
    end
    
    return lede
  end
  
  def previous
    self.class.first(:conditions => ["published_at < ? and blog_id = ?", self.published_at, self.blog_id], :limit => 1, :order => "published_at desc")
  end

  def next
    self.class.first(:conditions => ["published_at > ? and blog_id = ?", self.published_at, self.blog_id], :limit => 1, :order => "published_at asc")
  end
  
  #----------
  
  def link_path
    Rails.application.routes.url_helpers.blog_entry_path(
      :blog => self.blog.slug,
      :year => self.published_at.year, 
      :month => self.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :id => self.id,
      :slug => self.slug
    )
    
  end
end