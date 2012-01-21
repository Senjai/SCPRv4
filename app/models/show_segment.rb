class ShowSegment < ContentBase
  self.table_name =  'shows_segment'
  
  CONTENT_TYPE = "shows/segment"
  PRIMARY_ASSET_SCHEME = :segment_asset_scheme
  
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
    has "CRC32(CONCAT('shows/segment:',shows_segment.id))", :type => :integer, :as => :obj_key
    has "(shows_segment.segment_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
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
    
    # if we still don't have an episode, we've got a problem
    # FIXME: We desperately need to launch episode-independent segment publishing
    
    if !episode
      return ''
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