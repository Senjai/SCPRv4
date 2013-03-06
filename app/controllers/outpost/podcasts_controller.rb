class Outpost::PodcastsController < Outpost::ResourceController
  #---------------------
  # Outpost
  self.model = Podcast

  define_list do
    list_default_order "title"
    list_default_sort_mode "asc"

    column :title, sortable: true, default_sort_mode: "asc"
    column :slug
    column :source
    column :podcast_url
    column :keywords
    column :is_listed, header: "Listed?"

    filter :is_listed, title: "Listed?", collection: :boolean
  end
end
