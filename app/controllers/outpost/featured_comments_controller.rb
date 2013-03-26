class Outpost::FeaturedCommentsController < Outpost::ResourceController
  #----------------
  # Outpost
  self.model = FeaturedComment

  define_list do
    list_default_order "created_at"
    list_default_sort_mode "desc"

    column :bucket
    column :content
    column :username
    column :excerpt
    column :status
    column :created_at, sortable: true, default_sort_mode: "desc"

    filter :bucket_id, collection: -> { FeaturedCommentBucket.select_collection }
    filter :status, collection: -> { ContentBase.status_text_collect }
  end
end
