class Outpost::BlogsController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "is_active"
    l.default_sort_mode = "desc"
    
    l.column :name
    l.column :slug
    l.column :teaser,    header: "Tagline"
    l.column :is_active, header: "Active?", sortable: true, default_sort_mode: "desc"

    l.filter :is_active, title: "Active?", collection: :boolean
  end
end
