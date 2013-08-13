class ChangeTwitterUrlToTwitterHandleOnKpccPrograms < ActiveRecord::Migration
  def up
    rename_column :programs_kpccprogram, :twitter_url, :twitter_handle
  end

  def down
    rename_column :programs_kpccprogram, :twitter_handle, :twitter_url
  end
end
