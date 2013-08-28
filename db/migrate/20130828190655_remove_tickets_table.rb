class RemoveTicketsTable < ActiveRecord::Migration
  def up
    drop_table :tickets
  end

  def down
    create_table "tickets", :force => true do |t|
      t.integer  "user_id"
      t.string   "browser_info"
      t.string   "link"
      t.string   "summary"
      t.text     "description"
      t.integer  "status",       :null => false
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end

    add_index "tickets", ["status"], :name => "index_tickets_on_status"
    add_index "tickets", ["user_id"], :name => "index_tickets_on_user_id"
  end
end
