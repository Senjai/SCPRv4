class ExternalEpisode < ActiveRecord::Base
  # This also includes the admin routes, which we don't need.
  # Really that should be split into two modules, PublicRouting and
  # InternalRouting, or something.
  include Outpost::Model::Routing

  include Concern::Associations::AudioAssociation
  ROUTE_KEY = "episode"

  belongs_to :external_program
  has_many :external_episode_segments, order: "position"
  has_many :external_segments, through: :external_episode_segments

  # This needs to match ShowEpisode
  def route_hash
    {
      :show           => self.external_program.slug,
      :year           => self.air_date.year.to_s,
      :month          => "%02d" % self.air_date.month,
      :day            => "%02d" % self.air_date.day,
      :id             => self.id.to_s,
      :trailing_slash => true
    }
  end
end
