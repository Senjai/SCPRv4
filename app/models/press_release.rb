class PressRelease < ActiveRecord::Base
  include Concern::Validations::SlugValidation
  
  ROUTE_KEY = "press_release"
  has_secretary

  #-------------
  # Scopes
  
  #-------------
  # Associations
  
  #-------------
  # Validation
  validates :short_title, presence: true
  validates :slug, uniqueness: true
  
  #-------------
  # Callbacks
  before_validation :generate_slug, if: -> { self.slug.blank? }
  
  # Since this object doesn't have a #headline, just do this manually.
  # Could merge it in with GenerateSlugCallback eventually.
  def generate_slug
    if self.short_title.present?
      self.slug = self.short_title.parameterize[0...50].sub(/-+\z/, "")
    end
  end
  
  #-------------
  # Administration
  administrate do
    define_list do
      column :short_title
      column :created_at
    end
  end
  
  #-------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes title
    indexes body
  end
  
  #--------------
  
  def route_hash
    {
      :slug => self.slug
    }
  end
end
