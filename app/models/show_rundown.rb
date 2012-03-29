class ShowRundown < ActiveRecord::Base
  self.table_name =  'shows_rundown'
  
  belongs_to :episode, :class_name => "ShowEpisode"
  belongs_to :segment, :class_name => "ShowSegment"
  
  before_create :check_segment_order, :if => "segment_order.blank?"
  def check_segment_order
    last_rundown = ShowRundown.where(episode_id: episode.id).last
    if last_rundown.present? 
      self.segment_order = last_rundown.segment_order + 1
    else
      self.segment_order = 1
    end        
  end
end