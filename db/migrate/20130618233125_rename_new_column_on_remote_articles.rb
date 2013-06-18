class RenameNewColumnOnRemoteArticles < ActiveRecord::Migration
  def up
    rename_column :remote_articles, :new, :is_new
  end

  def down
    rename_column :remote_articles, :is_new, :new
  end
end
