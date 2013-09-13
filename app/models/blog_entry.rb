class BlogEntry < ActiveRecord::Base
  self.table_name = "blogs_entry"
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

  ROUTE_KEY = "blog_entry"

  ASSET_SCHEMES = [
    ["Top", "wide"],
    ["Right", "float"],
    ["Slideshow", "slideshow"],
    ["Video", "video"],
    ["Hidden", "hidden"]
  ]

  #------------------
  # Scopes

  #------------------
  # Association
  belongs_to :blog
  has_many :tagged, class_name: "TaggedContent", as: :content
  has_many :tags, through: :tagged, dependent: :destroy

  #------------------
  # Validation
  validates_presence_of :blog, if: :should_validate?

  def needs_validation?
    self.pending? || self.published?
  end

  #------------------
  # Callbacks

  #------------------
  # Sphinx
  define_index do
    indexes headline
    indexes body
    indexes bylines.user.name, as: :bylines

    has blog.id, as: :blog
    has status
    has published_at
    has updated_at

    has "CRC32(CONCAT('#{BlogEntry.content_key}:'," \
        "#{BlogEntry.table_name}.id))",
        type: :integer, as: :obj_key

    # For RSS feeds
    has "1", as: :is_source_kpcc, type: :boolean

    # For the homepage/category sections
    has "(#{BlogEntry.table_name}.blog_asset_scheme <=> 'slideshow')",
        type: :boolean, as: :is_slideshow

    has category.id, as: :category

    # For podcasts
    join audio
    has "COUNT(DISTINCT #{Audio.table_name}.id) > 0",
        type: :boolean, as: :has_audio

    # For the megamenu
    has category.is_news, as: :category_is_news

    # Required attributes for ContentBase.search
    has published_at, as: :public_datetime
    has "#{BlogEntry.table_name}.status = #{ContentBase::STATUS_LIVE}",
        as: :is_live, type: :boolean
  end



  #-------------------
  # Need to work around multi-american until we can figure
  # out how to merge those comments in with kpcc
  def disqus_identifier
    if dsq_thread_id.present? && wp_id.present?
      "#{wp_id} http://multiamerican.scpr.org/?p=#{wp_id}"
    else
      super
    end
  end

  #-------------------

  def disqus_shortname
    if dsq_thread_id.present? && wp_id.present?
      'scprmultiamerican'
    else
      super
    end
  end

  #-------------------
  # Blog Entries don't need the "KPCC" credit,
  # so override the default +byline_extras+
  # behavior to return empty array
  def byline_extras
    []
  end

  #-------------------

  def previous
    self.class.published.where("published_at < ? and blog_id = ?", self.published_at, self.blog_id).first
  end

  #-------------------

  def next
    self.class.published.where("published_at > ? and blog_id = ?", self.published_at, self.blog_id).first
  end

  #-------------------
  # This was made for the blog list pages - showing the full body
  # was too long, but just the teaser was too short.
  #
  # It should probably be in a presenter.
  def extended_teaser(*args)
    target      = args[0] || 800
    more_text   = args[1] || "Read More..."
    break_class = "story-break"

    content         = Nokogiri::HTML::DocumentFragment.parse(self.body)
    extended_teaser = Nokogiri::HTML::DocumentFragment.parse(nil)

    content.children.each do |child|
      break if (child.attributes["class"].to_s == break_class) || (extended_teaser.content.length >= target)
      extended_teaser.add_child child
    end

    extended_teaser.add_child "<p><a href=\"#{self.public_path}\">#{more_text}</a></p>"
    return extended_teaser.to_html
  end

  #-------------------

  def route_hash
    return {} if !self.persisted? || !self.persisted_record.published?
    {
      :blog           => self.persisted_record.blog.slug,
      :year           => self.persisted_record.published_at.year.to_s,
      :month          => "%02d" % self.persisted_record.published_at.month,
      :day            => "%02d" % self.persisted_record.published_at.day,
      :id             => self.persisted_record.id.to_s,
      :slug           => self.persisted_record.slug,
      :trailing_slash => true
    }
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
