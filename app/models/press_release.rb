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
  
  #-------------
  # Callbacks
    
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
