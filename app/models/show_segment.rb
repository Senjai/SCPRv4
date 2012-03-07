class ShowSegment < ContentBase
  self.table_name =  'shows_segment'
  
  CONTENT_TYPE = "shows/segment"
  PRIMARY_ASSET_SCHEME = :segment_asset_scheme
  
  belongs_to :show, :class_name => "KpccProgram"
  
  has_many :rundowns, :class_name => "ShowRundown", :foreign_key => "segment_id" 
  has_many :episodes, :through => :rundowns, :source => :episode, :order => "air_date asc" 
  
  belongs_to :enco_audio, :foreign_key => "enco_number", :primary_key => "enco_number", :conditions => proc { ["publish_date = ?",self.audio_date] }
  has_many :uploaded_audio, :as => "content"
  
  scope :published, where(:status => STATUS_LIVE).order("published_at desc")
  
  define_index do
    indexes title
    indexes lede
    indexes body
    has category.id, :as => :category
    has category.is_news, :as => :category_is_news
    has published_at
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('shows/segment:',shows_segment.id))", :type => :integer, :as => :obj_key
    has "(shows_segment.segment_asset_scheme <=> 'slideshow')", :type => :boolean, :as => :is_slideshow
    where "status = #{STATUS_LIVE}"
  end
  
  #----------
  
  def headline
    self.title
  end
  
  def byline_elements
    []
  end
  
  #----------
  
  def canFeature?
    self.assets.any? ? true : false
  end
  
  #----------
  
  def public_datetime
    return self.published_at
  end
  
  #----------
  
  def link_path
    Rails.application.routes.url_helpers.segment_path(
      :show => self.show.slug,
      :year => self.published_at.year, 
      :month => self.published_at.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.published_at.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :id => self.id,
      :slug => self.slug,
      :trailing_slash => true
    )
  end
end