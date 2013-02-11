class Flatpage < ActiveRecord::Base
  self.table_name = "flatpages_flatpage"
  has_secretary
  
  TEMPLATE_OPTIONS = [
    ["Normal (with sidebar)",   "inherit"],
    ["Full Width (no sidebar)", "full"],
    ["Crawford Family Forum",   "forum"],
    ["No Template",             "none"]
  ]
  
  # -------------------
  # Scopes
  scope :visible, -> { where(is_public: true) }

  # -------------------
  # Associations
  
  # -------------------
  # Validations
  validates :url, presence: true, uniqueness: true
  
  # -------------------
  # Callbacks
  before_validation :slashify
  def slashify
    if url.present? and path.present?
      self.url = "/#{path}/"
    end
  end
  
  before_validation :downcase_url
  def downcase_url
    if url.present? 
      self.url = url.downcase
    end
  end
  
  # -------------------
  # Administration
  administrate do
    define_list do
      list_order "updated_at desc"
      list_per_page 50
      
      column :url
      column :is_public, header: "Public?"
      column :redirect_url
      column :title
      column :updated_at
      
      filter :is_public, collection: :boolean
    end
  end

  # -------------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes url
    indexes title
    indexes description
    indexes redirect_url
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

  # -------------------
  # Override Outpost for this
  def link_path(options={})
    self.url
  end

  # -------------------

  def is_redirect?
    self.redirect_url.present?
  end
end
