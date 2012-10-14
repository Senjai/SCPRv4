class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :resource
      t.string :action
      t.timestamps
    end
    
    create_table :admin_user_permissions do |t|
      t.integer :admin_user_id
      t.integer :permission_id
      t.timestamps
    end
  end
end
