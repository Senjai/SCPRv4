class PijQuery < ActiveRecord::Base
  self.table_name = 'pij_query'
  outpost_model
  has_secretary

  include Concern::Scopes::SinceScope
  include Concern::Scopes::PublishedScope
  include Concern::Associations::AssetAssociation
  include Concern::Associations::RelatedLinksAssociation
  include Concern::Associations::RelatedContentAssociation
  include Concern::Associations::ContentAlarmAssociation
  include Concern::Associations::HomepageContentAssociation
  include Concern::Associations::MissedItContentAssociation
  include Concern::Validations::SlugValidation
  include Concern::Callbacks::GenerateSlugCallback
  include Concern::Callbacks::SphinxIndexCallback
  include Concern::Callbacks::SetPublishedAtCallback
  include Concern::Callbacks::CacheExpirationCallback
  include Concern::Callbacks::TouchCallback
  include Concern::Methods::PublishingMethods


  ROUTE_KEY = "pij_query"

  QUERY_TYPES = [
    ["Evergreen",             "evergreen"],
    ["News",                  "news"],
    ["Internal (not listed)", "utility"]
  ]

  # We need to keep the statuses mapped to the
  # ContentBase ones, since these are referenced
  # directly in HomepageContent, etc.
  STATUS_HIDDEN   = ContentBase::STATUS_DRAFT
  STATUS_PENDING  = ContentBase::STATUS_PENDING
  STATUS_LIVE     = ContentBase::STATUS_LIVE

  STATUS_TEXT = {
      STATUS_HIDDEN   => "Hidden",
      STATUS_PENDING  => "Pending",
      STATUS_LIVE     => "Live"
  }

  #------------
  # Scopes

  #------------
  # Association

  #------------
  # Validation
  validates :slug,        uniqueness: true
  validates :headline,    presence: true
  validates :teaser,      presence: true
  validates :body,        presence: true
  validates :query_type,  presence: true
  validates :pin_query_id, presence: true

  #------------
  # Callbacks

  #------------
  # Sphinx
  define_index do
    indexes headline
    indexes body
    indexes teaser
    indexes pin_query_id
    has published_at
    has status

    # Required attributes for ContentBase.search
    has published_at, as: :public_datetime
    has "#{PijQuery.table_name}.status = #{STATUS_LIVE}",
        as: :is_live, type: :boolean
  end


  class << self
    def status_select_collection
      STATUS_TEXT.map { |k, v| [v, k] }
    end
  end


  def pending?
    self.status == STATUS_PENDING
  end

  def published?
    self.status == STATUS_LIVE
  end

  def publish
    self.update_attributes(status: STATUS_LIVE)
  end

  def status_text
    STATUS_TEXT[self.status]
  end


  def to_article
    @to_article ||= Article.new({
      :original_object    => self,
      :id                 => self.obj_key,
      :title              => "KPCC Asks: " + self.headline,
      :short_title        => "KPCC Asks: " + self.headline,
      :public_datetime    => self.published_at,
      :teaser             => self.teaser,
      :body               => self.body,
      :assets             => self.assets,
      :byline             => "KPCC",
      :edit_url           => self.admin_edit_url
    })
  end


  #------------

  def route_hash
    return {} if !self.persisted? || !self.persisted_record.published?
    {
      :slug           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end
end
