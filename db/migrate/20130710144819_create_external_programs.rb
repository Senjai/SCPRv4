class CreateExternalPrograms < ActiveRecord::Migration
  def change
    create_table :external_programs do |t|
      t.string :slug
      t.string :title
      t.text :teaser
      t.text :description
      t.string :host
      t.string :produced_by
      t.string :airtime
      t.string :air_status
      t.string :web_url
      t.string :podcast_url
      t.string :rss_url
      t.string :importer_type
      t.text :sidebar

      t.timestamps

      t.index :slug
      t.index :air_status
    end
  end
end
