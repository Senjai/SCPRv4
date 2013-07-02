class AddNewPermissions < ActiveRecord::Migration
  def up
    Permission.create(resource: "ScheduleOccurrence")
    Permission.create(resource: "RecurringScheduleRule")
  end

  def down
    Permission.where(resource: ["ScheduleOccurrence", "RecurringScheduleRule"]).delete_all
  end
end
