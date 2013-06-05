class Outpost::FeaturedCommentsController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "created_at"
    l.default_sort_mode = "desc"

    l.column :bucket
    l.column :content
    l.column :username
    l.column :excerpt
    l.column :status
    l.column :created_at, sortable: true, default_sort_mode: "desc"

    l.filter :bucket_id, collection: -> { FeaturedCommentBucket.select_collection }
    l.filter :status, collection: -> { ContentBase.status_text_collect }
  end
end
