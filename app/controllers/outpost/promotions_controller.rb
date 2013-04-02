class Outpost::PromotionsController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "title"
    l.default_sort_mode = "asc"

    l.column :id
    l.column :title, sortable: true, default_sort_mode: "asc"
    l.column :created_at, sortable: true, default_sort_mode: "desc"
  end
end
