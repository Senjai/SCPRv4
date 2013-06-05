class PopulateTypeColumnForRemoteArticles < ActiveRecord::Migration
  def up
    RemoteArticle.update_all(type: "NprArticle")
  end

  def down
    RemoteArticle.update_all(type: nil)
  end
end
