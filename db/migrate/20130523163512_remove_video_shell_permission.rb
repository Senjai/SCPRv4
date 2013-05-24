class RemoveVideoShellPermission < ActiveRecord::Migration
  def up
    permission = Permission.find_by_resource!("VideoShell")
    Permission.delete(permission.id)
    UserPermission.where(id: permission.id).delete_all
  end

  def down
    Permission.create(resource: "VideoShell")
  end
end
