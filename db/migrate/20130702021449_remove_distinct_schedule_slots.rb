class RemoveDistinctScheduleSlots < ActiveRecord::Migration
  def up
    drop_table :distinct_schedule_slots
  end

  def down
    create_table "distinct_schedule_slots", :force => true do |t|
      t.string   "title"
      t.string   "info_url"
      t.datetime "starts_at"
      t.datetime "ends_at"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "distinct_schedule_slots", ["ends_at"], :name => "index_distinct_schedule_slots_on_ends_at"
    add_index "distinct_schedule_slots", ["starts_at"], :name => "index_distinct_schedule_slots_on_starts_at"
  end
end
