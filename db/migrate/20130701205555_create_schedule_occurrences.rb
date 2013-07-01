class CreateScheduleOccurrences < ActiveRecord::Migration
  def change
    create_table :schedule_occurrences do |t|
      t.string :title
      t.string :info_url
      t.integer :program_id
      t.string :program_type
      t.integer :recurring_schedule_slot_id
      t.datetime :starts_at
      t.datetime :ends_at
      t.timestamps
    end

    add_index :schedule_occurrences, [:program_type, :program_id]
    add_index :schedule_occurrences, [:starts_at, :ends_at]
    add_index :schedule_occurrences, :recurring_schedule_slot_id
  end
end
