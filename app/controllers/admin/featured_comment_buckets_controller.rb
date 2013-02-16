class Admin::FeaturedCommentBucketsController < Admin::ResourceController
  #-----------------
  # Outpost
  self.model = FeaturedCommentBucket

  define_list do
    list_default_order "title"
    list_default_sort_mode "asc"

    column :title, sortable: true, default_sort_mode: "asc"
    column :created_at, sortable: true, default_sort_mode: "desc"
    column :updated_at, sortable: true, default_sort_mode: "desc"
  end
end
