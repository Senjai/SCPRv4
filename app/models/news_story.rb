class NewsStory < ActiveRecord::Base
  self.table_name = 'news_story'
  outpost_model
  has_secretary

  include Concern::Scopes::SinceScope
  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AudioAssociation
  include Concern::Associations::AssetAssociation
  include Concern::Associations::RelatedContentAssociation
  include Concern::Associations::RelatedLinksAssociation
  include Concern::Associations::EmbedsAssociation
  include Concern::Associations::BylinesAssociation
  include Concern::Associations::CategoryAssociation
  include Concern::Associations::HomepageContentAssociation
  include Concern::Associations::FeaturedCommentAssociation
  include Concern::Associations::MissedItContentAssociation
  include Concern::Associations::EditionsAssociation
  include Concern::Validations::ContentValidation
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Callbacks::GenerateShortHeadlineCallback
  include Concern::Callbacks::GenerateTeaserCallback
  include Concern::Callbacks::GenerateSlugCallback
  include Concern::Callbacks::CacheExpirationCallback
  include Concern::Callbacks::RedisPublishCallback
  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Callbacks::HomepageCachingCallback
  include Concern::Callbacks::TouchCallback
  include Concern::Methods::ContentStatusMethods
  include Concern::Methods::PublishingMethods
  include Concern::Methods::CommentMethods

  self.disqus_identifier_base = "news/story"
  ROUTE_KEY = "news_story"

  SOURCES = [
    ['KPCC',                        'kpcc'],
    ['KPCC & wires',                'kpcc_plus_wire'],
    ['AP',                          'ap'],
    ['KPCC wire services',          'kpcc_wire'],
    ['NPR',                         'npr'],
    ['NPR & wire services',         'npr_wire'],
    ['New America Media',           'new_america'],
    ['NPR & KPCC',                  'npr_kpcc'],
    ['Center for Health Reporting', 'chr']
  ]

  ASSET_SCHEMES = [
    ["Top", "wide"],
    ["Right", "float"],
    ["Slideshow", "slideshow"],
    ["Video", "video"],
    ["Hidden", "hidden"]
  ]

  EXTRA_ASSET_SCHEMES = [
    ["Hidden", "hidden"],
    ["Sidebar", "sidebar"]
  ]

  #-------------------
  # Scopes

  #-------------------
  # Association

  #------------------
  # Validation
  def needs_validation?
    self.pending? || self.published?
  end

  #------------------
  # Callbacks

  #-------------------
  # Sphinx
  define_index do
    indexes headline
    indexes body
    indexes bylines.user.name, as: :bylines

    has status
    has published_at
    has updated_at
    has "CRC32(CONCAT('#{NewsStory.content_key}" \
        "#{Outpost::Model::Identifier::OBJ_KEY_SEPARATOR}'," \
        "#{NewsStory.table_name}.id))",
        type: :integer, as: :obj_key

    # For megamenu
    has category.is_news, as: :category_is_news

    # For RSS Feed
    has "(#{NewsStory.table_name}.source <=> 'kpcc')",
        as: :is_source_kpcc, type: :boolean

    # For category/homepage building
    has "(#{NewsStory.table_name}.story_asset_scheme <=> 'slideshow')",
        type: :boolean, as: :is_slideshow
    has category.id, as: :category

    # For podcasts
    join audio
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0",
        as: :has_audio, type: :boolean

    # Required attributes for ContentBase.search
    has published_at, as: :public_datetime
    has "#{NewsStory.table_name}.status = #{ContentBase::STATUS_LIVE}",
        as: :is_live, type: :boolean
  end

  #----------

  def route_hash
    return {} if !self.persisted? || !self.persisted_record.published?
    {
      :year           => self.persisted_record.published_at.year.to_s,
      :month          => "%02d" % self.persisted_record.published_at.month,
      :day            => "%02d" % self.persisted_record.published_at.day,
      :id             => self.persisted_record.id.to_s,
      :slug           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end

  #----------

  def byline_extras
    Array(self.news_agency)
  end

  #-------------------

  def to_article
    @to_article ||= Article.new({
      :original_object    => self,
      :id                 => self.obj_key,
      :title              => self.headline,
      :short_title        => self.short_headline,
      :public_datetime    => self.published_at,
      :teaser             => self.teaser,
      :body               => self.body,
      :category           => self.category,
      :assets             => self.assets,
      :audio              => self.audio.available,
      :attributions       => self.bylines,
      :byline             => self.byline,
      :edit_url           => self.admin_edit_url
    })
  end

  #-------------------

  def to_abstract
    @to_abstract ||= Abstract.new({
      :original_object        => self,
      :headline               => self.short_headline,
      :summary                => self.teaser,
      :source                 => "KPCC",
      :url                    => self.public_url,
      :assets                 => self.assets,
      :audio                  => self.audio.available,
      :category               => self.category,
      :article_published_at   => self.published_at
    })
  end
end
