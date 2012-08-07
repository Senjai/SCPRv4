class PijQuery < ActiveRecord::Base
  self.table_name = 'pij_query'

  QUERY_TYPES = [
    ["Evergreen",             "evergreen"],
    ["News",                  "news"],
    ["Internal (not listed)", "utility"]
  ]
  
  #------------
  # Administration
  administrate

  #------------
  # Association
  has_many :assets, class_name: "ContentAsset", as: :content
  
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
  
  def headline
    title
  end
  
  def short_headline
    title
  end
  
  def has_format?
    false
  end
  
  def link_path(options={})
    Rails.application.routes.url_helpers.pij_query_path(options.merge!({
      :slug => self.slug,
      :trailing_slash => true
    }))
  end
  
  #------------
  
  def remote_link_path
    "http://www.scpr.org#{self.link_path}"
  end
end