class Outpost::ShowEpisodesController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "air_date"
    l.default_sort_mode = "desc"

    l.column :headline
    l.column :show
    l.column :air_date, sortable: true, default_sort_mode: "desc"
    l.column :status
    l.column :published_at, sortable: true, default_sort_mode: "desc"
    
    l.filter :show_id, collection: -> { KpccProgram.select_collection }
    l.filter :status, collection: -> { ContentBase.status_text_collect }
  end
end
