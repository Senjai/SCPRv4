class RemoveRecurringScheduleSlots < ActiveRecord::Migration
  def up
    drop_table :recurring_schedule_slots
  end

  def down
    create_table "recurring_schedule_rules", :force => true do |t|
      t.text     "schedule"
      t.integer  "program_id"
      t.string   "program_type"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end

    add_index "recurring_schedule_rules", ["program_type", "program_id"], :name => "index_recurring_schedule_rules_on_program_type_and_program_id"
  end
end
