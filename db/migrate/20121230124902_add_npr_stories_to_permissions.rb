class AddNprStoriesToPermissions < ActiveRecord::Migration
  def up
    Permission.create(resource: "NprStory")
  end
  
  def down
    Permission.where(resource: "NprStory").destroy_all
  end
end
