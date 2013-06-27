class AddDistinctScheduleToPermissions < ActiveRecord::Migration
  def up
    Permission.create(resource: "DistinctScheduleSlot")
  end

  def down
    Permission.where(resource: "DistinctScheduleSlot").first.delete
  end
end
