class ExternalSegment < ActiveRecord::Base
  include Concern::Associations::AudioAssociation

  belongs_to :external_program
  belongs_to :external_episode
end
