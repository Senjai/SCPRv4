class Outpost::ContentShellsController < Outpost::ResourceController
  #----------------
  # Outpost
  self.model = ContentShell

  define_list do
    list_default_order "updated_at"
    list_default_sort_mode "desc"
    
    column :headline
    column :site
    column :byline
    column :published_at, sortable: true, default_sort_mode: "desc"
    column :status
    column :updated_at, sortable: true, default_sort_mode: "desc"
    
    filter :site, collection: -> { ContentShell.sites_select_collection }
    filter :status, collection: -> { ContentBase.status_text_collect }
  end
end
