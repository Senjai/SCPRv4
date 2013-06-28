class PijQuery < ActiveRecord::Base
  self.table_name = 'pij_query'
  outpost_model

  include Concern::Scopes::SinceScope
  include Concern::Associations::AssetAssociation
  include Concern::Validations::SlugValidation
  include Concern::Callbacks::GenerateSlugCallback
  include Concern::Callbacks::SphinxIndexCallback
  
  ROUTE_KEY = "pij_query"
  
  has_secretary
  
  QUERY_TYPES = [
    ["Evergreen",             "evergreen"],
    ["News",                  "news"],
    ["Internal (not listed)", "utility"]
  ]
  
  #------------
  # Scopes  
  scope :news,          -> { where(query_type: "news") }
  scope :evergreen,     -> { where(query_type: "evergreen") }

  scope :visible, -> {
    where('is_active = ? and published_at < ?', true, Time.now)
    .order("published_at desc")
  }
  
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

    # Required attributes for ContentBase.search
    has published_at, as: :public_datetime
    has is_active, as: :is_live, type: :boolean
  end
  
  #------------
  
  def published?
    self.is_active?
  end


  def to_article
    @to_article ||= Article.new({
      :original_object    => self,
      :id                 => self.obj_key,
      :title              => self.headline,
      :short_title        => self.headline,
      :public_datetime    => self.published_at,
      :teaser             => self.teaser,
      :body               => self.body,
      :assets             => self.assets,
      :byline             => "KPCC",
      :public_url         => self.public_url,
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
