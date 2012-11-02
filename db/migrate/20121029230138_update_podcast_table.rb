class UpdatePodcastTable < ActiveRecord::Migration
  def change
    add_column :podcasts_podcast, :source_type, :string
    rename_column :podcasts_podcast, :program_id, :source_id
    rename_column :podcasts_podcast, :link, :url
  end
end
