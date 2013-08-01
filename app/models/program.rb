# A module to make fetching Programs easier

module Program
  TYPES = [
    KpccProgram,
    ExternalProgram
  ]

  class << self
    def all
      TYPES.map(&:all).flatten
    end

    def find_by_slug(slug)
      KpccProgram.find_by_slug(slug) ||
      ExternalProgram.find_by_slug(slug)
    end
  end
end
