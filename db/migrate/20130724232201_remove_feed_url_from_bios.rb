class RemoveFeedUrlFromBios < ActiveRecord::Migration
  def up
    remove_column :bios_bio, :feed_url
  end

  def down
    add_column :bios_bio, :feed_url, :string
  end
end
