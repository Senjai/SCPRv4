class CreateExternalEpisodeSegments < ActiveRecord::Migration
  def change
    create_table :external_episode_segments do |t|
      t.integer :external_episode_id
      t.integer :external_segment_id
      t.integer :position
      t.timestamps
    end

    add_index :external_episode_segments, :external_segment_id
    add_index :external_episode_segments, [:external_episode_id, :position]
  end
end
