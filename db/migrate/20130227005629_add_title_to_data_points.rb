class AddTitleToDataPoints < ActiveRecord::Migration
  def change
    add_column :data_points, :title, :string
  end
end
