class CleanKpccProgramTable < ActiveRecord::Migration
  def up
    change_column :programs_kpccprogram, :slug, :string
    change_column :programs_kpccprogram, :title, :string
    change_column :programs_kpccprogram, :host, :string
    change_column :programs_kpccprogram, :airtime, :string
    change_column :programs_kpccprogram, :air_status, :string
    change_column :programs_kpccprogram, :audio_dir, :string

    change_column :programs_kpccprogram, :podcast_url, :string
    change_column :programs_kpccprogram, :twitter_url, :string
    change_column :programs_kpccprogram, :facebook_url, :string
    change_column :programs_kpccprogram, :rss_url, :string

    change_column :programs_kpccprogram, :teaser, :text
    change_column :programs_kpccprogram, :description, :text
    change_column :programs_kpccprogram, :sidebar, :text


    remove_index :programs_kpccprogram, name: :slug
    remove_index :programs_kpccprogram, name: :title

    add_index :programs_kpccprogram, :slug
    add_index :programs_kpccprogram, :is_featured
  end

  def down
    remove_index :programs_kpccprogram, :slug
    remove_index :programs_kpccprogram, :is_featured

    add_index :programs_kpccprogram, :slug, name: :slug
    add_index :programs_kpccprogram, :title, name: :title
  end
end
