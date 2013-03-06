class Outpost::MissedItBucketsController < Outpost::ResourceController
  #-----------------
  # Outpost
  self.model = MissedItBucket

  define_list do
    list_default_order "title"
    list_default_sort_mode "asc"
    list_per_page :all

    column :id
    column :title, sortable: true, default_sort_mode: "asc"
  end
end
