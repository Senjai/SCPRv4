# Public API for Programs
#
# When you pass in episodes, it has to be either an Array or a Relation
# This is to prevent accidental loading of hundreds of episodes.
class Program
  include Concern::Methods::AbstractModelMethods

  class << self
    def all
      (KpccProgram.all + ExternalProgram.all).map(&:to_program)
    end

    def find_by_slug(slug)
      program = KpccProgram.find_by_slug(slug) ||
      ExternalProgram.find_by_slug(slug)

      program.try(:to_program)
    end

    def find_by_slug!(slug)
      find_by_slug(slug) or raise ActiveRecord::RecordNotFound
    end
  end


  attr_accessor \
    :original_object,
    :id,
    :source,
    :title,
    :slug,
    :description,
    :host,
    :twitter_handle,
    :air_status,
    :airtime,
    :podcast_url,
    :rss_url,
    :episodes,
    :segments,
    :blog,
    :missed_it_bucket,
    :is_featured,
    :display_episodes,
    :display_segments

  alias_method :is_featured?, :is_featured
  alias_method :display_episodes?, :display_episodes
  alias_method :display_segments?, :display_segments


  def initialize(attributes={})
    @original_object  = attributes[:original_object]
    @id               = attributes[:id]
    @source           = attributes[:source]
    @title            = attributes[:title]
    @slug             = attributes[:slug]
    @description      = attributes[:description]
    @host             = attributes[:host]
    @twitter_handle   = attributes[:twitter_handle]
    @air_status       = attributes[:air_status]
    @airtime          = attributes[:airtime]
    @podcast_url      = attributes[:podcast_url]
    @rss_url          = attributes[:rss_url]
    @blog             = attributes[:blog]
    @missed_it_bucket = attributes[:missed_it_bucket]

    # Force to boolean
    @is_featured      = !!attributes[:is_featured]
    @display_segments = !!attributes[:display_segments]
    @display_episodes = !!attributes[:display_episodes]

    # Don't force these into an array, so it doesn't load ALL
    # of the episodes/segments (which could be thousands).
    @episodes         = attributes[:episodes]
    @segments         = attributes[:segments]
  end

  def to_program
    self
  end

  # Delegate get_link to original object, 
  # just so we don't have to redefine it.
  def get_link(type)
    if self.original_object
      self.original_object.get_link(type)
    end
  end

  # This is lame but necessary
  # Some programs (filmweek, business update) don't use
  # episodes, but instead use Segments as their "episodes".
  def uses_segments_as_episodes?
    !self.display_episodes? &&
    self.display_segments?
  end
end
