class Flatpage < ActiveRecord::Base
  # TODO: Once Flatpages are handled in Rails CMS, we will need to reload routes after any page is updated or created.
  
  # validates :url, presence: true
  
  self.table_name = "flatpages_flatpage" 
  default_scope where(enable_in_new_site: true)
end
