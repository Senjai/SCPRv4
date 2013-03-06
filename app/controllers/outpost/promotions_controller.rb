class Outpost::PromotionsController < Outpost::ResourceController
  #---------------
  # Outpost
  self.model = Promotion

  define_list do
    list_default_order "title"
    list_default_sort_mode "asc"

    column :id
    column :title, sortable: true, default_sort_mode: "asc"
    column :created_at, sortable: true, default_sort_mode: "desc"
  end
end
