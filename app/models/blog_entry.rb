class BlogEntry < ContentBase
  set_table_name "blogs_entry"
  
  CONTENT_TYPE = "blogs/entry"
  
  belongs_to :blog
  belongs_to :author, :class_name => "Bio"
  
  scope :published, where(:status => ContentBase::STATUS_LIVE).order("published_at desc")
  
  #----------
  
  def byline_elements
    [self.author]
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