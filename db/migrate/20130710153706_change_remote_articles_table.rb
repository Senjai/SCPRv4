class ChangeRemoteArticlesTable < ActiveRecord::Migration
  def up
    remove_index :remote_articles, :type
    rename_column :remote_articles, :type, :source

    RemoteArticle.where(source: "NprArticle").update_all(source: "npr")
    RemoteArticle.where(source: "ChrArticle").update_all(source: "chr")

    add_index :remote_articles, [:source, :article_id]
  end

  def down
    RemoteArticle.where(source: "npr").update_all(source: "NprArticle")
    RemoteArticle.where(source: "chr").update_all(source: "ChrArticle")

    remove_index :remote_articles, [:source, :article_id]
    add_index :remote_articles, :source

    rename_column :remote_articles, :source, :type
  end
end
