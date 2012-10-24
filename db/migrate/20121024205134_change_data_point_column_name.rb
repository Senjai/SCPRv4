class ChangeDataPointColumnName < ActiveRecord::Migration
  def change
    rename_column :data_points, :data, :data_value
    rename_column :data_points, :group, :group_name
    rename_column :data_points, :description, :notes
  end
end
