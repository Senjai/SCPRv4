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
  end


  attr_accessor \
    :original_object,
    :id,
    :source,
    :title,
    :slug,
    :description,
    :host,
    :air_status,
    :airtime,
    :podcast_url,
    :rss_url,
    :public_url,
    :episodes


  def initialize(attributes={})
    @original_object  = attributes[:original_object]
    @id               = attributes[:id]
    @source           = attributes[:source]
    @title            = attributes[:title]
    @slug             = attributes[:slug]
    @description      = attributes[:description]
    @host             = attributes[:host]
    @air_status       = attributes[:air_status]
    @airtime          = attributes[:airtime]
    @podcast_url      = attributes[:podcast_url]
    @rss_url          = attributes[:rss_url]
    @public_url       = attributes[:public_url]
    @episodes         = attributes[:episodes]
  end

  def to_program
    self
  end
end
