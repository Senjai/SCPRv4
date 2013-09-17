class ContentShell < ActiveRecord::Base
  self.table_name =  "contentbase_contentshell"
  outpost_model
  has_secretary

  include Concern::Scopes::SinceScope
  include Concern::Scopes::PublishedScope
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::AssetAssociation
  include Concern::Associations::BylinesAssociation
  include Concern::Associations::CategoryAssociation
  include Concern::Associations::HomepageContentAssociation
  include Concern::Associations::FeaturedCommentAssociation
  include Concern::Associations::MissedItContentAssociation
  include Concern::Associations::EditionsAssociation
  include Concern::Validations::PublishedAtValidation
  include Concern::Callbacks::CacheExpirationCallback
  include Concern::Callbacks::RedisPublishCallback
  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Callbacks::HomepageCachingCallback
  include Concern::Callbacks::TouchCallback
  include Concern::Methods::ContentStatusMethods
  include Concern::Methods::PublishingMethods


  #-------------------
  # Scopes
  #------------------
  # Association

  #------------------
  # Validation
  validates :status, presence: true
  validates :headline, presence: true # always
  validates :body, presence: true, if: :should_validate?
  validates :url, url: true, presence: true, if: :should_validate?
  validates :site, presence: true, if: :should_validate?

  #------------------

  class << self
    def sites_select_collection
      ContentShell.select("distinct site").order("site").map(&:site)
    end
  end

  #------------------

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
    has "CRC32(CONCAT('#{ContentShell.content_key}" \
        "#{Outpost::Model::Identifier::OBJ_KEY_SEPARATOR}'," \
        "#{ContentShell.table_name}.id))", 
        type: :integer, as: :obj_key

    # For category/homepage building
    has category.id, as: :category

    # For megamenu
    has category.is_news, as: :category_is_news

    # For Feeds - we only want to send our original content to RSS
    # (not stuff copies from AP or NPR, for example)
    has "1", as: :is_source_kpcc, type: :boolean

    # Required attributes for ContentBase.search
    has published_at, as: :public_datetime
    has "#{ContentShell.table_name}.status = #{ContentBase::STATUS_LIVE}", 
        as: :is_live, type: :boolean
  end


  # Override Outpost's routing methods for these
  def public_path(options={})
    self.public_url
  end

  def public_url(options={})
    self.url
  end


  def byline_extras
    [self.site]
  end


  def to_article
    @to_article ||= Article.new({
      :original_object    => self,
      :id                 => self.obj_key,
      :title              => self.headline,
      :short_title        => self.headline,
      :public_datetime    => self.published_at,
      :teaser             => self.body,
      :body               => self.body,
      :category           => self.category,
      :assets             => self.assets,
      :attributions       => self.bylines,
      :byline             => self.byline,
      :edit_url           => self.admin_edit_url
    })
  end

  def to_abstract
    @to_abstract ||= Abstract.new({
      :original_object        => self,
      :headline               => self.headline,
      :summary                => self.body,
      :source                 => self.site,
      :url                    => self.url,
      :assets                 => self.assets,
      :category               => self.category,
      :article_published_at   => self.published_at
    })
  end
end
