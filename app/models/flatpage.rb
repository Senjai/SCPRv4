class Flatpage < ActiveRecord::Base
  self.table_name = "flatpages_flatpage" 
  
  has_secretary
  
  # -------------------
  # Administration
  administrate do |admin|
    admin.define_list do |list|
      list.order    = "url"
      list.per_page = 100
      
      list.column "url"
      list.column "is_public", header: "Public?"
      list.column "redirect_url"
      list.column "title"
      list.column "updated_at"
    end
  end

  # -------------------

  TEMPLATE_OPTIONS = [
    ["Normal (with sidebar)",   "inherit"],
    ["Full Width (no sidebar)", "full"],
    ["No Template",             "none"]
  ]
  
  # -------------------
  # Scopes
  scope :visible, where(is_public: true)

  # -------------------
  # Validations
  validates :url, presence: true, uniqueness: true
  
  # -------------------
  # Callbacks
  before_validation :slashify
  before_validation :downcase_url
  after_save        :reload_routes, if: -> { self.url_changed? }
  
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
