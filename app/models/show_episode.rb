class ShowEpisode < ContentBase
  self.table_name =  "shows_episode"
  
  CONTENT_TYPE = 'shows/episode'
  
  belongs_to :show, :class_name => "KpccProgram"
  
  has_one :rundown, :class_name => "ShowRundown", :foreign_key => "episode_id"
  has_many :segments, :through => :rundown, :order => "segment_order asc", :class_name => "ShowSegment", :foreign_key => "segment_id"
    
  scope :published, where(:status => ContentBase::STATUS_LIVE).order("air_date desc, published_at desc")
  scope :upcoming, where(["status = ? and air_date >= ?",ContentBase::STATUS_PENDING,Date.today()]).order("air_date asc")
  
  define_index do
    indexes title
    indexes _teaser
    has "''", :as => :category, :type => :integer
    has "0", :as => :category_is_news, :type => :boolean
    has published_at
    has "1", :as => :is_source_kpcc, :type => :boolean
    has "CRC32(CONCAT('shows/episode:',shows_episode.id))", :type => :integer, :as => :obj_key
    has "0", :type => :boolean, :as => :is_slideshow
    where "status = #{STATUS_LIVE}"
    
  end
      
  #----------
  
  def headline
    self.title
  end
  
  def body
    return ""
  end

  #----------
  
  def link_path(options={})
    Rails.application.routes.url_helpers.episode_path(options.merge!({
      :show => self.show.slug,
      :year => self.air_date.year, 
      :month => self.air_date.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.air_date.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :trailing_slash => true
    }))
  end
end