class Admin::BlogsController < Admin::ResourceController
  #-------------
  # Outpost
  self.model = Blog

  define_list do
    list_order "is_active desc, name"
    list_per_page :all
    
    column :name
    column :slug
    column :teaser,    header: "Tagline"
    column :is_active, header: "Active?"
  end
end
