class PopulateExistingArticlesOrganization < ActiveRecord::Migration
  def up
    RemoteArticle.update_all(organization: "NPR")
  end

  def down
    RemoteArticle.update_all(organization: nil)
  end
end
