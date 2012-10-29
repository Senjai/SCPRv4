class ConvertPodcastTable < ActiveRecord::Migration
  def up
    Podcast.where("source_id is not null").update_all(source_type: "KpccProgram")
  end

  def down
  end
end
