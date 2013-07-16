class CreateExternalEpisodeSegments < ActiveRecord::Migration
  def change
    create_table :external_episode_segments do
      t.integer :external_episode_id
      t.integer :external_segment_id
      t.integer :position
      t.timestamps

      t.index :external_segment_id
      t.index [:external_episode_id, :position]
    end
  end
end
