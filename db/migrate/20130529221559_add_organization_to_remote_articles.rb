class AddOrganizationToRemoteArticles < ActiveRecord::Migration
  def change
    add_column :remote_articles, :organization, :string
  end
end
