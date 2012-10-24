class AddDataPointTable < ActiveRecord::Migration
  def change
    create_table "data_points" do |t|
      t.string "group"
      t.string "data_key"
      t.string "description"
      t.text "data"
      t.timestamps
    end
    
    add_index "data_points", "group"
    add_index "data_points", "data_key"
  end
end
