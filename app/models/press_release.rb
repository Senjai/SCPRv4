class PressRelease < ActiveRecord::Base
  include Model::Validations::SlugValidation  
  ROUTE_KEY = "press_release"
  
  #-------------
  # Administration
  administrate do
    define_list do
      column :short_title
      column :published_at
    end
  end
  
  has_secretary
  
  
  #-------------
  # Validation
  validates :short_title, presence: true
  
end
