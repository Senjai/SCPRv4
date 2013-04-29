class RemoveObjectYaml < ActiveRecord::Migration
  def up
    remove_column :versions, :object_yaml
  end

  def down
    add_column :versions, :object_yaml, :text
  end
end
