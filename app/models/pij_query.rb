class PijQuery < ActiveRecord::Base
  self.table_name = 'pij_query'
  outpost_model

  include Concern::Scopes::SinceScope
  include Concern::Associations::AssetAssociation
  include Concern::Validations::SlugValidation
  include Concern::Callbacks::GenerateSlugCallback
  include Concern::Methods::HeadlineMethods
  include Concern::Methods::TeaserMethods
  
  ROUTE_KEY       = "pij_query"
  
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

  scope :visible, -> { where(
    'is_active = :is_active and published_at < :time and ' \
    '(expires_at is null or expires_at > :time)', 
    is_active: true, time: Time.now
  ).order("published_at desc") }
  
  #------------
  # Association
  
  #------------
  # Validation
  validates :slug,        uniqueness: true
  validates :headline,    presence: true
  validates :body,        presence: true
  validates :query_type,  presence: true
  validates :query_url,   presence: true
  validates :form_height, presence: true
  
  #------------
  # Callbacks

  #------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes headline
    indexes body
    indexes query_url

    has published_at
  end
  
  #------------
  
  def published?
    is_active
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
