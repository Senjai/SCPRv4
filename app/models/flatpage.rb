class Flatpage < ActiveRecord::Base
  self.table_name = "flatpages_flatpage" 
  
  # -------------------
  # Administration
  administrate
  self.list_order = "url"
  self.list_fields = [
    ['url'],
    ['is_public', title: "Public?", display_helper: :display_boolean],
    ['redirect_url'],
    ['title'],
    ['updated_at', display_helper: :display_date ]
  ]

  # -------------------

  TEMPLATE_OPTIONS = [
    ["Normal (with sidebar)",   "inherit"],
    ["Full Width (no sidebar)", "full"],
    ["No Template",             "none"]
  ]
  
  # -------------------
  # Scopes
  default_scope where(is_public: true)

  # -------------------
  # Validations
  validates :url, presence: true, uniqueness: true
  
  # -------------------
  # Callbacks
  before_validation :slashify
  before_validation :downcase_url
  after_save :reload_routes, if: -> { self.url_changed? }
  
  # -------------------
  
  def slashify
    if url.present? and path.present?
      self.url = "/#{path}/"
    end
  end
  
  # -------------------
  
  def downcase_url
    if url.present? 
      self.url = url.downcase
    end
  end

  # -------------------

  def path
    url.gsub(/^\//, "").gsub(/\/$/, "")
  end
  
  # -------------------
  
  # Just to be safe while the URLs are still being created in mercer
  def url
    if self[:url].present?
      if self[:url] !~ /^\//
        "/#{self[:url]}"
      else
        self[:url]
      end
    end
  end
  
  def remote_link_path
    "http://www.scpr.org#{url}"
  end

  # -------------------
  
  private
  
    def reload_routes
      Scprv4::Application.reload_routes!
    end
end
