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
  DATE_ANCHOR = Time.new(2000, 01, 02, 0, 0, 0) # Sunday, January 1, 2000, 00:00:00

  administrate do
    define_list do
      list_per_page :all
      list_order :start_time
      
      column :program, display: proc { self.program.title }
      column :starts_at, display: proc { self.format_time(:starts_at) }
      column :ends_at, display: proc { self.format_time(:ends_at) }
    end
  end
  
  has_secretary
  
  #--------------
  # Associations
  belongs_to :program, polymorphic: true


  #--------------
  # Validations  
  validates :start_time, :end_time, :program, presence: true


  #--------------
  # Scopes


  #--------------
  
  class << self
    #--------------
    # Convert the stored relative minute
    # count into a real Time object.
    def as_time(seconds)
      Time.at(DATE_ANCHOR.to_i + seconds)
    end
    
    #--------------
    # Get the program(s) on at the requested time
    def on_at(time)
      second = time.second_of_week
      
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
        starts_before_break = self.where("end_time < start_time or end_time > :start_time", args).order(order).to_a
        starts_after_break  = self.where("start_time < :end_time", args).order(order).to_a
        slots = starts_before_break + starts_after_break
      end
      
      slots
    end
  end
  
  #--------------
  # Fake attributes to return real Time objects
  def starts_at
    @starts_at ||= RecurringScheduleSlot.as_time(self.start_time)
  end
  
  def ends_at
    @ends_at ||= RecurringScheduleSlot.as_time(self.end_time)
  end

  #--------------

  def next
    RecurringScheduleSlot.on_at(self.ends_at).first
  end

  #--------------

  def day
    self.starts_at.wday
  end
  
  #--------------
  
  def json
    {
      :start => self.starts_at,
      :end   => self.ends_at,
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
end
