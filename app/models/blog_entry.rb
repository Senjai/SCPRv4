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
    has category.is_news, :as => :category_is_news
    has published_at
    has "CRC32(CONCAT('blogs/entry:',blogs_entry.id))", :type => :integer, :as => :obj_key
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
    # first test if the first paragraph is an acceptable length
    fp = /^(.+)/.match(ActionController::Base.helpers.strip_tags(self.content).gsub("&nbsp;"," ").gsub(/\r/,''))
    
    if fp && fp[1].length < l
      # cool, return this
      return fp[1]
    else
      # try shortening this paragraph
      short = /^(.{#{l}}\w*)\W/.match(fp[1])
      
      if short
        return "#{short[1]}..."
      else
        return fp[1]
      end
    end    
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