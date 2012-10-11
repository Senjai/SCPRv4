class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :model
      t.string :action
      t.integer :admin_user_id
      t.timestamps
    end
  end
end
