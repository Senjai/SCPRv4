class ShowEpisode < ContentBase
  self.table_name =  "shows_episode"
  
  CONTENT_TYPE = 'shows/episode'
  
  belongs_to :show, :class_name => "KpccProgram"
  
  has_one :rundown, :class_name => "ShowRundown", :foreign_key => "episode_id"
  has_many :segments, :through => :rundown, :order => "segment_order asc", :class_name => "ShowSegment", :foreign_key => "segment_id"
  
  #belongs_to :program_audio, :foreign_key => "publish_date", :primary_key => "publish_date", :conditions => proc { ["slug = ?",self.show.slug] }  
  
  scope :published, where(:status => ContentBase::STATUS_LIVE).order("air_date desc")
  scope :upcoming, where(["status = ? and air_date >= ?",ContentBase::STATUS_PENDING,Date.today()]).order("air_date asc")
      
  #----------
  
  def headline
    self.title
  end
  
  #----------
  
  def _get_audio
    ProgramAudio.where(:slug => self.show.slug, :publish_date => self.air_date)
  end
    
  #----------
  
  def link_path(options={})
    Rails.application.routes.url_helpers.episode_path({
      :show => self.show.slug,
      :year => self.air_date.year, 
      :month => self.air_date.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => self.air_date.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :trailing_slash => true
    }.merge! options)
  end
end