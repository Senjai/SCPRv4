class ExternalEpisode < ActiveRecord::Base
  include Concern::Associations::AudioAssociation

  belongs_to :external_program
  has_many :external_episode_segments, order: "position"
  has_many :external_segments, through: :external_episode_segments
end
