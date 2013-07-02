class CreateRecurringScheduleRules < ActiveRecord::Migration
  def change
    create_table :recurring_schedule_rules do |t|
      t.text :schedule

      t.integer :program_id
      t.string :program_type

      t.timestamps
    end

    add_index :recurring_schedule_rules, [:program_type, :program_id]
  end
end
