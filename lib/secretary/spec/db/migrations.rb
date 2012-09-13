class SecretaryMigration < ActiveRecord::Migration
  def up
    $stdout.puts "*** Loading Schema"
    create_table "stories", force: true do |t|
      t.string  "headline"
      t.text    "body"
      t.timestamps
    end
    
    create_table "users", force: true do |t|
      t.string "name"
      t.timestamps
    end
    
    create_table "versions" do |t|
      t.integer   "version_number"
      t.string    "versioned_type"
      t.integer   "versioned_id"
      t.string    "user_id"
      t.text      "description"
      t.text      "object_yaml"
      t.datetime  "created_at"
    end    
  end
  
  def down
    drop_table "stories"
    drop_table "users"
    drop_table "versions"
  end
end
