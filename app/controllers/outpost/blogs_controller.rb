class Outpost::BlogsController < Outpost::ResourceController
  #-------------
  # Outpost
  self.model = Blog

  define_list do
    list_default_order "is_active"
    list_default_sort_mode "desc"
    list_per_page :all
    
    column :name
    column :slug
    column :teaser,    header: "Tagline"
    column :is_active, header: "Active?", sortable: true, default_sort_mode: "desc"

    filter :is_active, title: "Active?", collection: :boolean
  end
end
