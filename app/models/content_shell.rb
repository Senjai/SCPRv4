class ContentShell < ContentBase
  set_table_name "contentbase_contentshell"
  
  CONTENT_TYPE = "contentbase/shell"
  CONTENT_TYPE_ID = 115

  #----------
  
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