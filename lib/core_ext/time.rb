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
  # Find the relative number of seconds since
  # the beginning of the week for this Time
  def second_of_week
    (self - self.beginning_of_week(:sunday)).to_i
  end
end
