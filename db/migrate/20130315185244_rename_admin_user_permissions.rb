class RenameAdminUserPermissions < ActiveRecord::Migration
  def change
    rename_table :admin_user_permissions, :user_permissions
  end
end
