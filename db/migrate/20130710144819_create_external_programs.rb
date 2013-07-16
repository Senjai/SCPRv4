class CreateExternalPrograms < ActiveRecord::Migration
  def change
    create_table :external_programs do |t|
      t.string :slug
      t.string :title
      t.text :description
      t.string :host
      t.string :organization
      t.string :airtime
      t.string :air_status

      t.string :web_url
      t.string :podcast_url
      t.string :feed_url

      t.string :twitter_handle
      t.string :source
      t.integer :external_id
      t.boolean :is_episodic

      t.text :sidebar

      t.timestamps

      t.index :slug
      t.index :air_status
      t.index [:source, :external_id]
      t.index :is_episodic
    end
  end
end
