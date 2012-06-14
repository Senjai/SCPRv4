class Flatpage < ActiveRecord::Base
  self.table_name = "flatpages_flatpage" 
  administrate!
  self.list_order = "url"
  
  self.list_fields = [
    ['url'],
    ['is_public', title: "Public?", display_helper: :display_boolean],
    ['redirect_url'],
    ['title'],
    ['date_modified']
  ]
  
  # Temporary default_scope, this should be removed eventually and replaced with named scopes.
  default_scope where(enable_in_new_site: true, is_public: true)

  # TODO: Once Flatpages are handled in Rails CMS, we will need to reload routes after any page is updated or created.
  validates :url, presence: true, uniqueness: true
  
  before_validation :slashify
  before_validation :downcase_url
  
  after_save :reload_routes, if: -> { self.url_changed? }
  def reload_routes
    Scprv4::Application.reload_routes!
  end
  
  def slashify
    if url.present?
      stripped = url.gsub(/^\//, "").gsub(/\/$/, "")
      if stripped.present?
        self.url = "/#{stripped}/"
      end
    end
  end
  
  def downcase_url
    if url.present? 
      self.url = url.downcase
    end
  end

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
end
