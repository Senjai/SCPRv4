class ContentShell < ContentBase
  self.table_name =  "contentbase_contentshell"
  
  CONTENT_TYPE = "content/shell"
  ADMIN_PREFIX = "contentbase/contentshell"
  
  acts_as_content comments:           false, 
                  link_path:          false, # Defining them here
                  auto_published_at:  false
  
  # -------------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.order = "published_at desc"
      list.column "headline"
      list.column "site"
      list.column "bylines"
      list.column "status"
      list.column "published_at"
    end
  end
  
  define_index do
    indexes headline
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has "CRC32(CONCAT('content/shell:',contentbase_contentshell.id))", :type => :integer, :as => :obj_key
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "0", :as => :is_slideshow, :type => :boolean
    has "0", :as => :has_audio, :type => :boolean
    where "status = #{STATUS_LIVE}"
  end
  
  #----------
  
  def link_path(options={})
    self.url
  end
  
  # Override acts_as_content's default behavior
  def remote_link_path
    self.url
  end
  
  #----------
  
  def byline_elements
    [self.site]
  end
  
  #----------
end