class RenameNprIdToArticleId < ActiveRecord::Migration
  def change
    rename_column :remote_articles, :npr_id, :article_id
  end
end
