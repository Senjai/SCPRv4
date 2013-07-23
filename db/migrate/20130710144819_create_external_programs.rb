class CreateExternalPrograms < ActiveRecord::Migration
  def change
    rename_table :programs_otherprogram, :external_programs

    change_table :external_programs do |t|
      t.change :slug, :string
      t.change :title, :string
      t.change :teaser, :text
      t.change :description, :text
      t.change :host, :string
      t.change :airtime, :string
      t.change :air_status, :string
      t.change :web_url, :string
      t.change :podcast_url, :string
      t.change :rss_url, :string
      t.change :sidebar, :text

      t.rename :produced_by, :organization

      t.string :twitter_handle
      t.string :source
      t.integer :external_id
      t.string :feed_type
    end

    remove_index :external_programs, name: "slug"
    remove_index :external_programs, name: "title"
    remove_index :external_programs, name: "index_programs_otherprogram_on_air_status"

    add_index :external_programs, :title # for sorting
    add_index :external_programs, :slug
    add_index :external_programs, :air_status
    add_index :external_programs, [:source, :external_id]
    add_index :feed_type
  end
end
