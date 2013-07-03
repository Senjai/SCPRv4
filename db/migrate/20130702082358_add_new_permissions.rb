class AddNewPermissions < ActiveRecord::Migration
  def up
    p = Permission.find_by_resource("RecurringScheduleSlot")
    p.update_column(:resource, "RecurringScheduleRule")

    p = Permission.find_by_resource("DistinctScheduleSlot")
    p.update_column(:resource, "ScheduleOccurrence")
  end

  def down
    p = Permission.find_by_resource("RecurringScheduleRule")
    p.update_column(:resource, "RecurringScheduleSlot")

    p = Permission.find_by_resource("ScheduleOccurrence")
    p.update_column(:resource, "DistinctScheduleSlot")
  end
end
