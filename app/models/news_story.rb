class NewsStory < ContentBase
  self.table_name =  'news_story'
  
  CONTENT_TYPE = 'news/story'
  CONTENT_TYPE_ID = 15
  
  PRIMARY_ASSET_SCHEME = :story_asset_scheme
    
  has_many :links, :as => "content"
  
  belongs_to :enco_audio, :foreign_key => "enco_number", :primary_key => "enco_number", :conditions => proc { ["publish_date = ?",self.audio_date] }
  has_many :uploaded_audio, :as => "content"
  
  define_index do
    indexes headline
    indexes lede
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has "(news_story.source <=> 'kpcc')", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('news/story:',news_story.id))", :type => :integer, :as => :obj_key
    has "(news_story.story_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
    where "status = #{STATUS_LIVE}"
  end
  
  scope :this_week, lambda { where("published_at > ?", Date.today - 7) }
  
  #----------
  
  def link_path(options={})
    Rails.application.routes.url_helpers.news_story_path({
      :year => self.published_at.year, 
      :month => self.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :id => self.id,
      :slug => self.slug,
      :trailing_slash => true
    }.merge! options)
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