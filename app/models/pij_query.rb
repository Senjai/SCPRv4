class PijQuery < ActiveRecord::Base
  self.table_name = 'pij_query'
  CONTENT_TYPE = "pij/query"
  
  acts_as_content headline:       :title, 
                  comments:       false
  
  QUERY_TYPES = [
    ["Evergreen",             "evergreen"],
    ["News",                  "news"],
    ["Internal (not listed)", "utility"]
  ]
  
  #------------
  # Administration
  administrate
  
  #------------
  # Scopes
  scope :news,      where(query_type: "news")
  scope :evergreen, where(query_type: "evergreen")
  
  scope :visible, -> { where(
    'is_active = :is_active and published_at < :time and ' \
    '(expires_at is null or expires_at > :time)', 
    is_active: true, time: Time.now
  ).order("published_at desc") }
  
  #------------
  # Validation
  validates :slug,        presence: true, uniqueness: true
  validates :query_type,  presence: true
  validates :query_url,   presence: true
  validates :title,       presence: true

  #------------
  
  def link_path(options={})
    Rails.application.routes.url_helpers.pij_query_path(options.merge!({
      :slug => self.slug,
      :trailing_slash => true
    }))
  end
end