# An article is an abstract object, which is not persisted,
# but rather meant to be built manually from the attributes
# of another object.
#
# An Article should be the publc API for the parts of our
# presentational layer which mix different types of content.
# So in the areas where we're displaying blog entries, news
# stories, events, etc. all together, we shouldn't have to
# worry about whether one of the classes has defined an
# "audio" instance method, for example. We just coerce
# everything into an Article, and then *know* that it will
# work. This eliminates a lot of the "fakery" going on in
# our classes - stuff like `def teaser; self.body; end`.
#
# This also makes it super-easy to mix any content into the 
# normal flow of things. If one day we decided that Bios
# should show up in the normal rotation on the homepage 
# (this is a contrived example to illustrate the point),
# it would be a simple matter of defining a `to_article` 
# instance method on the Bio class. How a Bio gets coerced
# into an Article is up to the developer.
#
# An Article object doesn't do anything fancy. It just acts
# exactly the way we need it to.
#
# This should pretty much match up with what our client API
# response is, but it doesn't necessarily have to.
class Article

  attr_accessor \
    :original_object,
    :id,
    :title,
    :short_title,
    :public_datetime,
    :category,
    :teaser,
    :body,
    :assets,
    :audio,
    :attributions,
    :byline,
    :public_url,
    :edit_url # Should this really be an attribute, or should we delegate?

  
  def initialize(attributes={})
    @original_object  = attributes[:original_object]
    @id               = attributes[:id]
    @title            = attributes[:title]
    @short_title      = attributes[:short_title]
    @public_datetime  = attributes[:public_datetime]
    @category         = attributes[:category]
    @teaser           = attributes[:teaser]
    @body             = attributes[:body]
    @assets           = Array(attributes[:assets])
    @audio            = Array(attributes[:audio])
    @attributions     = Array(attributes[:attributions])
    @byline           = attributes[:byline]
    @public_url       = attributes[:public_url]
    @edit_url         = attributes[:edit_url]
  end


  def to_article
    self
  end


  # Steal the ActiveRecord behavior for object comparison.
  # Compare Article ID with the comparison object's ID
  def ==(comparison_object)
    super ||
      comparison_object.instance_of?(self.class) &&
      self.id.present? &&
      self.id == comparison_object.id
  end
  alias :eql? :==


  def to_abstract
    @to_abstract ||= Abstract.new({
      :original_object        => self,
      :headline               => self.title,
      :summary                => self.teaser,
      :source                 => self.byline,
      :url                    => self.public_url,
      :assets                 => self.assets,
      :audio                  => self.audio,
      :category               => self.category,
      :article_published_at   => self.public_datetime
    })
  end


  def asset
    @asset ||= self.assets.first
  end
end
