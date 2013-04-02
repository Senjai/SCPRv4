class Outpost::VideoShellsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order = "published_at"
    l.default_sort_mode = "desc"

    l.column :headline
    l.column :slug
    l.column :byline
    l.column :published_at, sortable: true, default_sort_mode: "desc"
    l.column :status

    l.filter :status, collection: -> { ContentBase.status_text_collect }
    l.filter :bylines, collection: -> { Bio.select_collection }
  end
end
