class AddTypeToRemoteArticles < ActiveRecord::Migration
  def change
    add_column :remote_articles, :type, :string
  end
end
