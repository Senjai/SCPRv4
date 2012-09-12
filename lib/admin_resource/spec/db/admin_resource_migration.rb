class AdminResourceMigration < ActiveRecord::Migration
  def up
    create_table "people", force: true do |t|
      t.string  "name"
      t.string  "email"
      t.string  "location"
      t.string  "age"
      t.timestamps
    end   
  end
  
  def down
    drop_table "people"
  end
end