class Outpost::MissedItBucketsController < Outpost::ResourceController
  outpost_controller
  #-----------------
  # Outpost
  self.model = MissedItBucket

  define_list do |l|
    l.default_order = "title"
    l.default_sort_mode = "asc"

    l.column :id
    l.column :title, sortable: true, default_sort_mode: "asc"
    l.column :slug
  end
end
