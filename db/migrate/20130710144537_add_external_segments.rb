class AddExternalSegments < ActiveRecord::Migration
  def change
    create_table :external_segments do |t|
      t.string :title
      t.text :teaser
      t.integer :external_program_id
      t.string :source
      t.string :external_id
      t.string :public_url
      t.datetime :published_at
      t.timestamps
    end

    add_index :external_segments, [:source, :external_id]
    add_index :external_segments, :external_program_id
    add_index :external_segments, :published_at
  end
end
