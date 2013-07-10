class AddExternalSegments < ActiveRecord::Migration
  def change
    create_table :external_segments do |t|
      t.string :title
      t.text :teaser
      t.integer :external_program_id
      t.integer :external_episode_id
      t.datetime :published_at
      t.timestamps

      t.index :external_program_id
      t.index :external_episode_id
      t.index :published_at
    end
  end
end
