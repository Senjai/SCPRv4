class AddTimestampsToRemoteArticles < ActiveRecord::Migration
  def change
    add_column :remote_articles, :created_at, :datetime, null: false
    add_column :remote_articles, :updated_at, :datetime, null: false

    RemoteArticle.update_all(created_at: Time.now, updated_at: Time.now)
  end
end
