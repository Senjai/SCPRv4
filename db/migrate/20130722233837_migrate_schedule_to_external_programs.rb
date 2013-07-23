class MigrateScheduleToExternalPrograms < ActiveRecord::Migration
  def up
    RecurringScheduleRule.where(program_type: "OtherProgram").update_all(program_type: "ExternalProgram")
    ScheduleOccurrence.where(program_type: "OtherProgram").update_all(program_type: "ExternalProgram")
  end

  def down
    RecurringScheduleRule.where(program_type: "ExternalProgram").update_all(program_type: "OtherProgram")
    ScheduleOccurrence.where(program_type: "ExternalProgram").update_all(program_type: "OtherProgram")
  end
end
