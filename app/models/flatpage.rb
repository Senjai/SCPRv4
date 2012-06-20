class Flatpage < ActiveRecord::Base
  self.table_name = "flatpages_flatpage" 
  
  # Temporary default_scope, this should be removed eventually and replaced with named scopes.
  default_scope where(enable_in_new_site: true, is_public: true)

  # TODO: Once Flatpages are handled in Rails CMS, we will need to reload routes after any page is updated or created.
  # Or, come up with a better solution for routing them.
  validates :url, presence: true, uniqueness: true
  
  before_validation :slashify
  before_validation :downcase_url
  
  def slashify
    if url.present? and path.present?
      self.url = "/#{path}/"
    end
  end
  
  def downcase_url
    if url.present? 
      self.url = url.downcase
    end
  end
  
  def path
    url.gsub(/^\//, "").gsub(/\/$/, "")
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
