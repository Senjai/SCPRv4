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
      column :headline
      column :published_at
      column :teaser
      column :link, display: :display_npr_link
    end
  end
  
  #---------------
  # Sphinx
  define_index do
    indexes :headline
    indexes :teaser
    indexes :link
  end
  
  def import
  end
end
