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
  end  

  #----------
  # Return a block of schedule between the two times
  # The first argument (start) is INCLUSIVE
  # The second argument (end) is EXCLUSIVE
  #
  # Example usage:
  #   time = Chronic.parse("Friday 8am")
  #   Schedule.between(time, time + 8.hours)
  #
  def between(start_time, end_time)
    recurring = RecurringScheduleSlot.between(start_time, end_time)
  end
  
  
  def at(args={})
    time = args[:time] || Time.now()
    hours = args[:hours] || 4
    
    programs = []

    # first, get what's on at our start time
    start = self.on_at(time)
    programs << start
    
    # now get what's on at our end time
    pend = self.on_at( time + 60*60*hours )
    
    # now get anything in between
    begin
      s = programs[-1].up_next
      programs << s
    end until ( s == pend )
    
    return programs
  end
  
  
  #----------
  
  def up_next
    # if our current program ends before the end of the day, we want whatever comes on next today
    if self.end_time.hour > 0
      # today...
      nextp = self.class.where("day = ? and start_time >= ?",self.day,self.end_time.to_s(:time)).order("start_time asc").first
      
      if self._date && nextp
        nextp._date = self._date
      end
      
      return nextp
    else
      # ends at midnight, so we want the first show tomorrow
      nextp = self.class.where("day = ?", ( self.day <= 5 ? self.day + 1 : 0 ) ).order("start_time asc").first
      
      if self._date && nextp
        nextp._date = self._date + 1
      end
      
      return nextp
    end
  end
end