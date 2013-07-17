class ExternalSegment < ActiveRecord::Base
  include Concern::Associations::AudioAssociation

  belongs_to :external_program
  has_many :external_episode_segments
  
  has_many :external_episodes,
    :through   => :external_episode_segments,
    :dependent => :destroy

end
