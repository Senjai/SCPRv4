class CleanupPodcastTable < ActiveRecord::Migration
  def up
    rename_table :podcasts_podcast, :podcast
    
    change_table :podcast do |t|
      t.change :slug, :string, null: true
      t.change :title, :string, null: true
      t.change :url, :string, null: true
      t.change :podcast_url, :string, null: true, default: nil
      t.change :itunes_url, :string, null: true, default: nil
      t.change :image_url, :string, null: true
      t.change :author, :string, null: true
      t.change :keywords, :string, null: true
      t.change :duration, :string, null: true
      t.change :item_type, :string, null: true
      t.change :source_type, :string, null: true
      t.change :description, :text, null: true
    end
  end

  def down
  end
end
