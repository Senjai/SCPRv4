class RemoveActionFromPermissions < ActiveRecord::Migration
  def up    
    remove_column :permissions, :action
  end

  def down
    add_column :permissions, :action, :string
  end
end
