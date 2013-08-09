class Episode
  include Concern::Methods::AbstractModelMethods

  attr_accessor \
    :original_object,
    :id,
    :title,
    :summary,
    :air_date,
    :assets,
    :audio,
    :program,
    :segments


  def initialize(attributes={})
    @original_object  = attributes[:original_object]
    @id               = attributes[:id]
    @program          = attributes[:program]
    @title            = attributes[:title]
    @summary          = attributes[:summary]
    @air_date         = attributes[:air_date]
    @assets           = Array(attributes[:assets])
    @audio            = Array(attributes[:audio])
    @segments         = Array(attributes[:segments])
  end

  def to_episode
    self
  end
end
