class CreateDistinctScheduleSlots < ActiveRecord::Migration
  def change
    create_table :distinct_schedule_slots do |t|
      t.string :title
      t.string :info_url
      t.datetime :starts_at
      t.datetime :ends_at
      t.timestamps
    end
    
    add_index :distinct_schedule_slots, :starts_at
    add_index :distinct_schedule_slots, :ends_at
  end
end
