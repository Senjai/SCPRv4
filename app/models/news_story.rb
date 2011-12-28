class NewsStory < ContentBase
  set_table_name 'news_story'
  
  CONTENT_TYPE = 'news/story'
  CONTENT_TYPE_ID = 15
    
  has_many :links, :as => "content"
  
  belongs_to :enco_audio, :foreign_key => "enco_number", :primary_key => "enco_number", :conditions => proc { ["publish_date = ?",self.audio_date] }
  has_many :uploaded_audio, :as => "content"
  
  has_many :story_categories, :foreign_key => 'story_id'
  has_many :categories, :through => :story_categories
    
  define_index do
    indexes headline
    indexes lede
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    where "status = #{STATUS_LIVE}"
  end
  
  scope :published, where(:status => STATUS_LIVE)
  
  #----------
  
  def canFeature?
    self.story_asset_scheme == "slideshow" ? true : false
  end
  
  #----------
  
  def link_path
    Rails.application.routes.url_helpers.news_story_path(
      :year => self.published_at.year, 
      :month => self.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :id => self.id,
      :slug => self.slug,
      :trailing_slash => true
    )
  end
  
  #----------
  
  def byline_elements
    bylines = []
        
    if self.news_agency
      bylines << self.news_agency
    end
    
  end
    
  #----------
  
end