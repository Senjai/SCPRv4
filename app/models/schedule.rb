##
# Schedule
#
# This module is a collaborator which acts 
# as an API for grabbing schedule slots 
# across both schedule models.
#
# Example usage:
#
#   Schedule.on_at(Time.now)
#
module Schedule
  extend self
  
  #----------
  # Get the slot(s) on at the given time
  def on_at(time)
    recurring = RecurringScheduleSlot.on_at(time)
    distinct  = DistinctScheduleSlot.on_at(time)

    (recurring + distinct).sort_by(&:starts_at)
  end

  #----------
  # Return a block of schedule between the two times
  # The first argument (start) is INCLUSIVE
  # The second argument (end) is EXCLUSIVE
  #
  # Example usage:
  #
  #   Schedule.block(Time.now, 8.hours)
  #
  def block(start_time, length)
    recurring = RecurringScheduleSlot.block(start_time, length)
    distinct  = DistinctScheduleSlot.block(start_time, length)

    (recurring + distinct).sort_by(&:starts_at)
  end
end
