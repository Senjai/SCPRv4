class AddExternalSegments < ActiveRecord::Migration
  def change
    create_table :external_segments do |t|
      t.string :title
      t.text :teaser
      t.integer :external_program_id
      t.string :source
      t.integer :external_id
      t.string :external_url
      t.datetime :published_at
      t.timestamps

      t.index [:source, :external_id]
      t.index :external_program_id
      t.index :published_at
    end
  end
end
