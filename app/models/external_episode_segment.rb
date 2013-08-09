class ExternalEpisodeSegment < ActiveRecord::Base
  belongs_to :external_episode
  belongs_to :external_segment
end
