class ExternalEpisode < ActiveRecord::Base
  include Concern::Associations::AudioAssociation

  belongs_to :external_program
  has_mnay :external_segments
end
