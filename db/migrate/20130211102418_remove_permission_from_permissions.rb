class RemovePermissionFromPermissions < ActiveRecord::Migration
  def up
    p = Permission.find_by_resource("Permission")
    p.destroy if p 
  end

  def down
    puts "no"
  end
end
