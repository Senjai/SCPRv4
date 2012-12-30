class PijQuery < ActiveRecord::Base
  include Concern::Scopes::SinceScope
  include Concern::Associations::AssetAssociation
  include Concern::Callbacks::GenerateSlugCallback
  include Concern::Methods::HeadlineMethods
  include Concern::Methods::TeaserMethods
  
  self.table_name = 'pij_query'
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
  validates :slug,        presence: true, uniqueness: true
  validates :headline,    presence: true
  validates :body,        presence: true
  validates :query_type,  presence: true
  validates :query_url,   presence: true
  validates :form_height, presence: true
  
  #------------
  # Callbacks
  
  #------------
  # Administration
  administrate do
    define_list do
      column :headline
      column :slug
      column :query_type
      column :is_active, header: "Active?"
      column :is_featured, header: "Featured?"
      column :published_at
      
      filter :query_type, collection: -> { PijQuery::QUERY_TYPES }
      filter :is_active, collection: :boolean
      filter :is_featured, collection: :boolean
    end
  end

  #------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes headline
    indexes body
    indexes query_url
  end
  
  #------------
  
  def published?
    !!is_active
  end

  #------------
  
  def route_hash
    return {} if !self.published? || !self.persisted?
    {
      :slug           => self.persisted_record.slug,
      :trailing_slash => true
    }
  end
end
