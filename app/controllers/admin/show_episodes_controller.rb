class Admin::ShowEpisodesController < Admin::ResourceController
  #---------------
  # Outpost
  self.model = ShowEpisode

  define_list do
    list_default_order "air_date"
    list_default_sort_mode "desc"

    column :headline
    column :show
    column :air_date, sortable: true, default_sort_mode: "desc"
    column :status
    column :published_at, sortable: true, default_sort_mode: "desc"
    
    filter :show_id, collection: -> { KpccProgram.select_collection }
    filter :status, collection: -> { ContentBase.status_text_collect }
  end
end
