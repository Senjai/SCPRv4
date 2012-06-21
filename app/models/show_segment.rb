class ShowSegment < ContentBase
  administrate!
  self.table_name =  'shows_segment'
  
  CONTENT_TYPE = "shows/segment"
  PRIMARY_ASSET_SCHEME = :segment_asset_scheme
  
  belongs_to :show, :class_name => "KpccProgram"
  
  has_many :rundowns, :class_name => "ShowRundown", :foreign_key => "segment_id"
  has_many :episodes, :through => :rundowns, :source => :episode, :order => "air_date asc" 

  define_index do
    indexes title
    indexes _teaser
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('shows/segment:',shows_segment.id))", :type => :integer, :as => :obj_key
    has "(shows_segment.segment_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0", :as => :has_audio, :type => :boolean
    where "status = #{STATUS_LIVE}"
    join audio
  end
  
  #----------
  
  def episode
    episodes.first
  end
  
  def sister_segments
    if episodes.present?
      episode.segments.published.where("shows_segment.id != ?", self.id)
    else
      show.segments.published.where("shows_segment.id != ?", self.id).limit(5)
    end
  end
  
  def headline
    self.title
  end
  
  def byline_elements
    [self.show.title]
  end
  
  #----------
  
  def canFeature?
    self.assets.present?
  end
  
  def has_format?
    false
  end
  
  #----------
  
  def public_datetime
    return self.published_at
  end
  
  #----------
  
  def link_path(options={})
    Rails.application.routes.url_helpers.segment_path(options.merge!({
      :show => self.show.slug,
      :year => self.published_at.year, 
      :month => self.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :id => self.id,
      :slug => self.slug,
      :trailing_slash => true
    }))
  end
end