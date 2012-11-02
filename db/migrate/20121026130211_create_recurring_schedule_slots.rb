class CreateRecurringScheduleSlots < ActiveRecord::Migration
  def change
    create_table :recurring_schedule_slots do |t|
      t.integer :program_id
      t.string :program_type
      t.integer :start_time
      t.integer :end_time
      t.timestamps
    end
    
    add_index :recurring_schedule_slots, [:program_id, :program_type]
    add_index :recurring_schedule_slots, [:start_time, :end_time]
  end
end
