class RenameNprStoryLinkToUrl < ActiveRecord::Migration
  def change
    rename_column :remote_articles, :link, :url
  end
end
