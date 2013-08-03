# A module to make fetching Programs easier
# When you pass in episodes, it has to be either an Array or a Relation
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


  def initialize(attributes={})
    @original_object  = attributes[:original_object]
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
