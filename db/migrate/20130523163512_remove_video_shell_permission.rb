class RemoveVideoShellPermission < ActiveRecord::Migration
  def up
    Permission.find_by_resource!("VideoShell").destroy
  end

  def down
    Permission.create(resource: "VideoShell")
  end
end
