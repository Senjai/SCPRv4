class RemoveAgrees < ActiveRecord::Migration
  def up
    remove_column :tickets, :agrees
  end

  def down
    add_column :tickets, :agrees, :integer
  end
end
