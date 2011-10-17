class ShowSegment < ContentBase
  set_table_name 'shows_segment'
  
  CONTENT_TYPE = "shows/segment"
  
  belongs_to :show, :class_name => "KpccProgram"
  
  #----------
  
  def link_path(episode)
    Rails.application.routes.url_helpers.segment_path(
      :show => self.show.slug,
      :year => episode.air_date.year, 
      :month => episode.air_date.month.to_s.sub(/^[^0]$/) { |n| "0#{n}" }, 
      :day => episode.air_date.day.to_s.sub(/^[^0]$/) { |n| "0#{n}" },
      :id => self.id,
      :slug => self.slug
    )
  end
end