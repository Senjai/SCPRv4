class RenameTwitterToTwitterHandleOnBios < ActiveRecord::Migration
  def up
    rename_column :bios_bio, :twitter, :twitter_handle
    Bio.all.each do |bio|
      if bio.twitter_handle.present?
        bio.update_column(:twitter_handle, bio.twitter_handle.gsub(/@/, ""))
      end
    end
  end

  def down
    rename_column :bios_bio, :twitter_handle, :twitter

    Bio.all.each do |bio|
      if bio.twitter_handle.present?
        bio.update_column(:twitter_handle, "@#{bio.twitter_handle}")
      end
    end

  end
end
