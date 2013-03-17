class Outpost::SectionsController < Outpost::ResourceController
  #--------------
  # Outpost
  self.model = Section

  define_list do
    list_default_order "title"
    list_default_sort_mode "asc"
    list_per_page :all
    
    column :id
    column :title
    column :slug
  end
end
