class Outpost::AbstractsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order = "updated_at"
    l.default_sort_mode = "desc"
    
    l.column :headline
    l.column :source
    l.column :url, display: :display_link
    l.column :article_published_at, sortable: true, default_sort_mode: "desc"
    l.column :updated_at, header: "Last Updated", sortable: true, default_sort_mode: "desc"

    l.filter :source, collection: -> { Abstract.sources_select_collection }
  end
end
