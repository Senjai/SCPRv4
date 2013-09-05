class ExternalSegment < ActiveRecord::Base
  include Outpost::Model::Identifier
  include Concern::Associations::AudioAssociation

  belongs_to :external_program
  has_many :external_episode_segments

  has_many :external_episodes,
    :through   => :external_episode_segments,
    :dependent => :destroy

  validates :external_url, url: { allow_blank: true }

  def to_article
    @to_article ||= Article.new({
      :original_object    => self,
      :id                 => self.obj_key,
      :title              => self.title,
      :short_title        => self.title,
      :public_datetime    => self.published_at,
      :teaser             => self.teaser,
      :body               => self.teaser,
      :audio              => self.audio.available,
      :byline             => self.external_program.organization
    })
  end

  def public_url
    self.external_url
  end
end
