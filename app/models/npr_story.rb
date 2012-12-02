class NprStory < ActiveRecord::Base
  self.table_name = "npr_npr_story"

  #---------------
  # Scopes
  
  #---------------
  # Associations

  #---------------
  # Validations

  #---------------
  # Callbacks

  #---------------
  # Administration
  administrate do
    define_list do
    end
  end
  
  #---------------
  # Sphinx
  define_index do
  end
  
  def import
  end
end
