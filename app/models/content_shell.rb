class ContentShell < ContentBase
  set_table_name "contentbase_contentshell"
  
  CONTENT_TYPE = "content/shell"
  CONTENT_TYPE_ID = 115
  
  define_index do
    indexes headline
    indexes lede
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has pub_at, :as => :published_at
    has "CRC32(CONCAT('content/shell:',contentbase_contentshell.id))", :type => :integer, :as => :obj_key
    where "status = #{STATUS_LIVE}"
  end
  

  #----------
  
  def _short_headline
    self.headline
  end
  
  def _short_headline?
    true
  end
  
  def canFeature?
    self.assets.any? ? true : false
  end
  
  def link_path
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