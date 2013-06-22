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
class ScheduleSlot < ActiveRecord::Base
  self.abstract_class = true
  
  class << self
    #----------
    # Get the slot(s) on at the given time
    def on_at(time)
      DistinctScheduleSlot.on_at(time) or 
      RecurringScheduleSlot.on_at(time)
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


  def next
    self.class.on_at(self.ends_at)
  end
end
