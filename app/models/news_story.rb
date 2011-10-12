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
  
  def byline_elements
    bylines = []
    
    if self.primary_reporter
      bylines << self.primary_reporter
    end

    if self.secondary_reporter
      bylines << self.primary_reporter
    end
    
    if !self.primary_reporter && !self.secondary_reporter
      bylines << self.byline
    end
    
    if self.news_agency
      bylines << self.news_agency
    end
    
  end
    
  #----------
  
end