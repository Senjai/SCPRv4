class Admin::SectionsController < Admin::ResourceController
  #--------------
  # Outpost
  self.model = Section

 define_list do
    list_per_page :all
    
    column :id
    column :title
    column :slug
  end
end
