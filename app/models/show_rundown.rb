class ShowRundown < ActiveRecord::Base
  self.table_name = 'shows_rundown'
  
  belongs_to :episode, class_name: "ShowEpisode"
  belongs_to :segment, class_name: "ShowSegment"
  
  #------------------------
  
  def simple_json
    {
      "id"       => self.segment.try(:obj_key), # TODO Store this in join table
      "position" => self.position.to_i
    }
  end

  before_create :check_position, if: -> { self.position.blank? }
  
  def check_position
    if last_rundown = ShowRundown.where(episode_id: episode.id).last
      self.position = last_rundown.position + 1
    else
      self.position = 1
    end
  end
end
