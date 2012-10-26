##
# Time extension
#
# Add some methods to help calculate 
# weekly recurring events
#
# Requires ActiveSupport
#
class Time  
  #---------------
  # Time since the Epoch in given
  # interval. Basically an enhanced
  # Time#to_i
  def time_since_epoch(interval=:seconds)
    seconds = self.to_i
    case interval
      when :seconds then seconds
      when :minutes then seconds/60
      when :hours   then seconds/60/60
      else raise ArgumentError, "Available options are [:seconds, :minutes, :hours]"
    end
  end
  
  #---------------
  # Find the relative number of minutes since
  # the beginning of the week for this Time
  def time_since_beginning_of_week(interval=:seconds)
    self.time_since_epoch(interval) - self.beginning_of_week(:sunday).time_since_epoch(interval)
  end
  
  #---------------
  # Convenience methods
  def second_of_week
    self.time_since_beginning_of_week(:seconds)
  end
  
  def minute_of_week
    self.time_since_beginning_of_week(:minutes)
  end
  
  def hour_of_week
    self.time_since_beginning_of_week(:hours)
  end
end
