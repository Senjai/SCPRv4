class Article
  ATTRIBUTES = [
    :original_object,
    :id,
    :title,
    :short_title,
    :public_datetime,
    :teaser,
    :body,
    :assets,
    :byline,
    :permalink
  ]

  attr_accessor *ATTRIBUTES
  
  def initialize(attributes={})
    @original_object  = attributes[:object]
    @id               = attributes[:id]
    @title            = attributes[:title]
    @short_title      = attributes[:short_title]
    @public_datetime  = attributes[:public_datetime]
    @teaser           = attributes[:teaser]
    @body             = attributes[:body]
    @assets           = attributes[:assets]
    @byline           = attributes[:byline]
    @permalink        = attributes[:permalink]
  end


  def to_article
    self
  end
end
