class Outpost::PodcastsController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "title"
    l.default_sort_mode = "asc"

    l.column :title, sortable: true, default_sort_mode: "asc"
    l.column :slug
    l.column :source
    l.column :podcast_url
    l.column :keywords
    l.column :is_listed, header: "Listed?"

    l.filter :is_listed, title: "Listed?", collection: :boolean
  end
end
