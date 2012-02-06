class ContentShell < ContentBase
  self.table_name =  "contentbase_contentshell"
  
  CONTENT_TYPE = "content/shell"
  CONTENT_TYPE_ID = 115
  ADMIN_PREFIX = "contentbase/contentshell"
  
  define_index do
    indexes headline
    indexes lede
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has pub_at, :as => :published_at
    has "CRC32(CONCAT('content/shell:',contentbase_contentshell.id))", :type => :integer, :as => :obj_key
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "0", :as => :is_slideshow, :type => :boolean
    where "status = #{STATUS_LIVE}"
  end
  
  scope :published, where(:status => STATUS_LIVE).order("pub_at asc")

  #----------
  
  def _short_headline
    self.headline
  end
  
  def _short_headline?
    true
  end
  
  def body
    self._teaser
  end
  
  #----------
  
  def link_path
    self.url
  end
  
  def remote_link_path
    self.url
  end
  
  #----------
  
  def byline_elements
    [self.site]
  end
  
  #----------
  
  def published_at
    self.pub_at
  end
end