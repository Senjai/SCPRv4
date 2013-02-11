class Admin::PodcastsController < Admin::ResourceController
  #---------------------
  # Outpost
  self.model = Podcast

  define_list do
    column :title
    column :slug
    column :source
    column :podcast_url
    column :keywords
    column :is_listed
  end
end
