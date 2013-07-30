class ChangeRemoteArticlesTable < ActiveRecord::Migration
  def up
    rename_column :remote_articles, :type, :source

    RemoteArticle.where(source: "NprArticle").update_all(source: "npr")
    RemoteArticle.where(source: "ChrArticle").update_all(source: "chr")
  end

  def down
    RemoteArticle.where(source: "npr").update_all(source: "NprArticle")
    RemoteArticle.where(source: "chr").update_all(source: "ChrArticle")
    rename_column :remote_articles, :source, :type
  end
end
