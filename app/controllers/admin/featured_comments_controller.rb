class Admin::FeaturedCommentsController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = FeaturedComment

  define_list do
    list_default_order "published_at"
    list_default_sort_mode "desc"

    column :bucket
    column :content, display: :display_content
    column :username
    column :excerpt
    column :status
    column :published_at, sortable: true, default_sort_mode: "desc"

    filter :bucket_id, collection: -> { FeaturedCommentBucket.select_collection }
    filter :status, collection: -> { ContentBase.status_text_collect }
  end
end
