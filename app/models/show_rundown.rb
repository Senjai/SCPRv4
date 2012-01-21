class ShowRundown < ActiveRecord::Base
  self.table_name =  'shows_rundown'
  
  belongs_to :episode, :class_name => "ShowEpisode"
  belongs_to :segment, :class_name => "ShowSegment"
end