class NewsStory < ContentBase
  set_table_name 'news_story'
  
  CONTENT_TYPE = 'news/story'
  CONTENT_TYPE_ID = 15
  
  scope :published, where(:status => STATUS_LIVE)
  
  has_many :links, :as => "content"
  belongs_to :primary_reporter, :class_name => "Bio"
  belongs_to :secondary_reporter, :class_name => "Bio"  
  
  belongs_to :enco_audio, :foreign_key => "enco_number", :conditions => proc { ["publish_date = ?",self.audio_date] }
  has_many :uploaded_audio, :as => "content"
  
  #----------
  
  def link_path
    Rails.application.routes.url_helpers.news_story_path(
      :year => self.published_at.year, 
      :month => self.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :id => self.id,
      :slug => self.slug
    )
  end
  
  #----------
  
  def byline_elements
    bylines = []
    
    if self.primary_reporter && self.primary_reporter != ""
      bylines << self.primary_reporter
    end

    if self.secondary_reporter && self.secondary_reporter != ""
      bylines << self.primary_reporter
    end
    
    if !self.primary_reporter && !self.secondary_reporter && self.byline != ""
      bylines << self.byline
    end
    
    if self.news_agency
      bylines << self.news_agency
    end
    
  end
    
  #----------
  
end