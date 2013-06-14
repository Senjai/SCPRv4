class AddAbstractAndEditionPermissions < ActiveRecord::Migration
  def up
    Permission.create(resource: "Abstract")
    Permission.create(resource: "Edition")
  end

  def down
    Permission.where(resource: ["Abstract", "Edition"]).delete_all
  end
end
