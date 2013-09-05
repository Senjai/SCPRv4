class Podcast < ActiveRecord::Base
  outpost_model
  has_secretary

  include Concern::Callbacks::SphinxIndexCallback

  ROUTE_KEY = "podcast"

  ITEM_TYPES = [
    ["Episodes", 'episodes'],
    ["Segments", 'segments'],
    ["Content", 'content']
  ]

  SOURCES = ["KpccProgram", "ExternalProgram", "Blog"]

  CONTENT_CLASSES = [
    NewsStory,
    ShowSegment,
    BlogEntry
  ]

  #-------------
  # Scopes

  #-------------
  # Association
  belongs_to :source, polymorphic: true
  belongs_to :category

  #-------------
  # Validation
  validates :slug, uniqueness: true, presence: true
  validates :title, presence: true

  validates :url, presence: true, url: true
  validates :podcast_url, presence: true, url: true
  validates :itunes_url, url: { allow_blank: true }
  validates :image_url, url: { allow_blank: true }

  #-------------
  # Callbacks

  #-------------
  # Sphinx
  define_index do
    indexes title, sortable: true
    indexes slug
    indexes description
  end

  #-------------

  def content(limit=25)
    @content ||= begin
      klasses    = []
      conditions = {}

      case self.source_type
      when "KpccProgram"
        conditions.merge!(program: self.source.id)
        klasses.push ShowEpisode if self.item_type == "episodes"
        klasses.push ShowSegment if self.item_type == "segments"

      when "ExternalProgram"
        # ExternalProgram won't actually have any content
        # So, just incase this method gets called,
        # just return an empty array.
        return []

      when "Blog"
        conditions.merge!(blog: self.source.id)
        klasses.push BlogEntry

      else
        klasses = [NewsStory, BlogEntry, ShowSegment, ShowEpisode] if item_type == "content"
      end

      results = content_query(limit, klasses, conditions)
      results.map(&:to_article)
    end
  end

  #-------------

  def route_hash
    return {} if !self.persisted?
    { slug: self.slug }
  end

  #-------------

  private

  def content_query(limit, klasses, conditions={})
    ContentBase.search({
      :with    => conditions.reverse_merge({
        :has_audio => true
      }),
      :classes => klasses,
      :limit   => limit
    })
  end
end
