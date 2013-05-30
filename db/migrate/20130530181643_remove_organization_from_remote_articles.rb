class RemoveOrganizationFromRemoteArticles < ActiveRecord::Migration
  def up
    remove_column :remote_articles, :organization
  end

  def down
    add_column :remote_articles, :organization, :string
  end
end
