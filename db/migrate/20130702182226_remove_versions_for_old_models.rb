class RemoveVersionsForOldModels < ActiveRecord::Migration
  def up
    Secretary::Version.where(versioned_type: ["RecurringScheduleSlot", "DistinctScheduleSlot"]).destroy_all
  end

  def down
  end
end
