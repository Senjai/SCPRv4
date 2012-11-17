##
# RecurringScheduleSlot
#
# A recurring program on the schedule
#
# The `start_time` and `end_time` attributes are
# the number of _seconds_ from the beginning of 
# the week.
#
class RecurringScheduleSlot < ActiveRecord::Base
  has_secretary
  
  #--------------
  # Scopes
  
  #--------------
  # Associations
  belongs_to :program, polymorphic: true
  
  #--------------
  # Validations
  validates :start_time, :end_time, :program, presence: true
  
  #--------------
  # Callbacks
  
  #--------------
  # Administration
  administrate do
    define_list do
      list_per_page :all
      list_order "start_time"
      
      column :program, display: proc { self.program.title }
      column :starts_at, display: proc { self.format_time(:starts_at) }
      column :ends_at, display: proc { self.format_time(:ends_at) }
    end
  end

  #--------------
  # Sphinx
  acts_as_searchable
  
  define_index do
    indexes program.title
  end
  
  #--------------
  
  class << self
    #--------------
    # Convert the seconds into a real Time 
    # object. To be used with seconds relative
    # to the beginning of the week, such as
    # the ones stored in the database.
    #
    # Usage:
    #
    #   time = RecurringTimeSlot.last
    #   time.start_time 
    #   # => 169200
    #
    #   RecurringTimeSlot.as_time(time.start_time)
    #   # => 2012-10-29 23:00:00 -0700
    #
    # This method should be used only for 
    # displaying times, because it does some 
    # freaky DST adjusting stuff.
    #
    def as_time(seconds)
      week = Time.now.beginning_of_week(:sunday)
      time = week + seconds.seconds
      
      # Adjust for DST to display time properly.
      # If DST is ADDING an hour, then we should
      # ADD an hour here so it displays times, 
      # properly, and vice-versa.
      if to_standard?(week, time)
        time += 1.hour
      elsif to_dst?(week, time)
        time -= 1.hour
      end
      
      time
    end
    
    #--------------
    # Get the slots on at the requested time
    #
    # As this method returns an ARRAY, be sure to
    # call #first on it to return just one slot!
    # The idea is that there might be more than one
    # thing going on, which may or may not ever 
    # happen.
    #
    # Usage:
    #
    #   RecurringScheduleSlot.on_at(Time.now)
    #
    # Super-nifty with ActiveSupport's relative time functions:
    #
    #   RecurringScheduleSlot.on_at(8.hours.from_now)
    #
    def on_at(time)
      week   = time.beginning_of_week(:sunday)
      second = time.second_of_week
      
      # Adjust for DST so we can query properly
      # If DST is ADDING an hour (DST -> not DST),
      # Then we need to REMOVE that hour here,
      # and vice-versa.
      if to_standard?(week, time)
        second -= 1.hour
      elsif to_dst?(week, time)
        second += 1.hour
      end
      
      # First try the most common pattern,
      # where the requested time is between
      # start_time and end_time. This will
      # work 99% of the time.
      slots = self.where("start_time < end_time and start_time <= :time and end_time > :time", time: second).order("start_time").to_a
      return slots if slots.present?
      
      # In the case where the requested time 
      # is near the week reset (12am Sunday),
      # then the above query won't pick up
      # anything, because either the slot's
      # start_time will be too high (if the 
      # requested time is after the reset), 
      # or its end_time will be too low (if
      # the time is before the reset).
      #
      # For now we'll assume that if no slots
      # were found in the above query, then 
      # we're in that situation. This is okay
      # because there aren't (and probably 
      # never will be) any gaps in the schedule.
      slots = self.where("start_time > end_time and (start_time <= :time or end_time > :time)", time: second).order("start_time").to_a
    end
    
    #--------------
    # Block of schedule
    def block(start_time, length)
      end_time        = start_time + length
      different_weeks = end_time.wday < start_time.wday
      args            = { start_time: start_time.second_of_week, end_time: end_time.second_of_week }
      order           = "start_time"
      
      # If the requested block doesn't bridge
      # the cycle reset, then just do the normal
      # thing and find any records that end after
      # the requested start, and start before the
      # requested end.
      #
      # Otherwise, find everything that ends after
      # the requested start, OR which starts
      # before the requested end. This is okay
      # because it will go right up to the minimum
      # (0) and maximum (604800) limits.
      if !different_weeks
        slots = self.where("end_time > :start_time and start_time < :end_time", args).order(order).to_a
      else
        before = self.where("end_time < start_time or end_time > :start_time", args).order(order).to_a
        after  = self.where("start_time < :end_time", args).order(order).to_a
        slots  = before + after
      end
      
      slots
    end

    #--------------
    private
    def to_standard?(time1, time2)
      time1.dst? && !time2.dst?
    end
    
    def to_dst?(time1, time2)
      !time1.dst? && time2.dst?
    end
  end
  
  
  #--------------
  # Methods to return real Time objects.
  def starts_at
    at_time(:start_time)
  end

  def ends_at
    at_time(:end_time)
  end

  def day
    self.starts_at.wday
  end
  
  
  #--------------
  # Has the slot ended already this week?
  def past?
    Time.now.second_of_week > self.end_time
  end
  
  #--------------
  # If the slot splits the weeks, see if now is
  # above the start time, or now is below the end time.
  # Otherwise, do the normal thing and just check
  # if now is in-between start and end times.
  def current?
    now = Time.now.second_of_week
    
    if !split_weeks?
      self.start_time <= now && self.end_time > now
    else
      now > self.start_time || now < self.end_time
    end
  end
  
  #--------------
  # Has the slot not yet started this week?
  def upcoming?
    Time.now.second_of_week < self.start_time
  end

  
  #--------------

  def next
    RecurringScheduleSlot.on_at(self.ends_at).first
  end

  
  #--------------
  
  def json
    {
      :start => self.starts_at.to_i,
      :end   => self.ends_at.to_i,
      :title => self.program.title,
      :link  => self.program.link_path
    }
  end

  #--------------
  #--------------
  # TODO Move these to a Presenter
  def show_modal?
    program.display_episodes
  end
  
  def format_time(time=:starts_at)
    attribute = self.send(time)
    str_time = attribute.strftime("%H:%M")
    
    if str_time == "00:00"
      "midnight"
    elsif str_time == "12:00"
      "noon"
    elsif str_time.match /:00/
      attribute.strftime("%l%P")
    else
      attribute.strftime("%l:%M%P")
    end
  end

  #--------------

  private

  #--------------
  # This will only be true for one slot...
  # But we need to check.
  def split_weeks?
    @split_weeks ||= self.end_time < self.start_time
  end
  
  #--------------
  # If the slot is now or upcoming, use
  # this week's date. If it's past, use
  # next week's date.
  def at_time(attribute)
    time = RecurringScheduleSlot.as_time(self.send(attribute))
    time += 1.week if self.past?
    time
  end
end
