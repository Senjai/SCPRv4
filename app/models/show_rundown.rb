class ShowRundown < ActiveRecord::Base
  self.table_name = 'shows_rundown'
  
  belongs_to :episode, class_name: "ShowEpisode"
  belongs_to :segment, class_name: "ShowSegment"
  
  #------------------------
  
  def simple_json
    {
      "id"       => self.segment.try(:obj_key), # TODO Store this in join table
      "position" => self.segment_order.to_i
    }
  end

  before_create :check_segment_order, if: -> { self.segment_order.blank? }
  
  def check_segment_order
    if last_rundown = ShowRundown.where(episode_id: episode.id).last
      self.segment_order = last_rundown.segment_order + 1
    else
      self.segment_order = 1
    end
  end
end
