class Outpost::ContentShellsController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "updated_at"
    l.default_sort_mode = "desc"
    
    l.column :headline
    l.column :site
    l.column :byline
    l.column :published_at, sortable: true, default_sort_mode: "desc"
    l.column :status
    l.column :updated_at, sortable: true, default_sort_mode: "desc"
    
    l.filter :site, collection: -> { ContentShell.sites_select_collection }
    l.filter :status, collection: -> { ContentBase.status_text_collect }
  end
end
