class RenameNprStoryPermission < ActiveRecord::Migration
  def up
    p = Permission.find_by_resource("NprStory")
    p.update_attribute(:resource, "RemoteArticle")
  end

  def down
    p = Permission.find_by_resource("RemoteArticle")
    p.update_attribute(:resource, "NprStory")
  end
end
