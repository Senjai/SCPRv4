class RenameNprStoriesToRemoteArticles < ActiveRecord::Migration
  def change
    rename_table :npr_npr_story, :remote_articles
  end
end
