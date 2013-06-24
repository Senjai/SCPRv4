class RemoveScheduleProgramTable < ActiveRecord::Migration
  def up
    drop_table :schedule_program
  end

  def down
    # why
  end
end
