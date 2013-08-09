class RemoveUrlColumns < ActiveRecord::Migration
  def up
    remove_column :blogs_blog, :facebook_url
    remove_column :blogs_blog, :feed_url

    remove_column :programs_kpccprogram, :podcast_url
    remove_column :programs_kpccprogram, :rss_url
    remove_column :programs_kpccprogram, :facebook_url

    remove_column :external_programs, :web_url
  end

  def down
    change_table :blogs_blog do |t|
      t.string :facebook_url
      t.string :feed_url
    end

    change_table :programs_kpccprogram do |t|
      t.string :podcast_url
      t.string :rss_url
      t.string :facebook_url
    end

    change_table :external_programs do |t|
      t.string :web_url
    end
  end
end
