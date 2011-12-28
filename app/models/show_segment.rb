class ShowSegment < ContentBase
  set_table_name 'shows_segment'
  
  CONTENT_TYPE = "shows/segment"
  
  belongs_to :show, :class_name => "KpccProgram"
  
  has_many :rundowns, :class_name => "ShowRundown", :foreign_key => "segment_id" 
  has_many :episodes, :through => :rundowns, :source => :episode, :order => "air_date asc" 
  
  define_index do
    indexes title
    indexes lede
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has created_at, :as => :published_at
    where "status = #{STATUS_LIVE}"
  end
  
  #----------
  
  def headline
    self.title
  end
  
  def byline_elements
    [self.show.title]
  end
  
  #----------
  
  def canFeature?
    self.assets.any? ? true : false
  end
  
  #----------
  
  def public_datetime(episode=nil)
    if !episode
      episode = self.episodes.first
    end

    return episode.air_date
  end
  
  #----------
  
  def link_path(episode=nil)
    if !episode
      episode = self.episodes.first
    end
    
    Rails.application.routes.url_helpers.segment_path(
      :show => self.show.slug,
      :year => episode.air_date.year, 
      :month => episode.air_date.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => episode.air_date.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :id => self.id,
      :slug => self.slug,
      :trailing_slash => true
    )
  end
end