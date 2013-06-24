##
# RecurringScheduleSlot
#
# A recurring program on the schedule
#
# The `start_time` and `end_time` attributes are
# the number of _seconds_ from the beginning of 
# the week.
#
class RecurringScheduleSlot < ScheduleSlot
  outpost_model
  has_secretary

  include Concern::Callbacks::SphinxIndexCallback

  INPUT_FORMAT = %r|(?<day>[a-zA-Z]+) +(?<hour>\d\d?)\:(?<min>\d\d)|

  # Because Time::DAYS_INTO_WEEK starts on Monday,
  # but we've decided to start on Sunday.
  DAYS_INTO_WEEK = {
    :sunday       => 0,
    :monday       => 1,
    :tuesday      => 2,
    :wednesday    => 3,
    :thursday     => 4,
    :friday       => 5,
    :saturday     => 6
  }

  #--------------
  # Scopes
  
  #--------------
  # Associations
  belongs_to :program, polymorphic: true
  
  #--------------
  # Validations
  validates :program, presence: true 
  validate :time_strings_can_be_parsed

  #--------------
  # Callbacks
  before_validation :set_program_from_obj_key
  before_save :set_times_from_input_strings

  #--------------
  # Sphinx  
  define_index do
    indexes program.title
    has start_time
  end
  
  #--------------

  class << self
    def program_select_collection
      kpcc_programs  = KpccProgram.all.map { |p| [p.title, p.obj_key] }
      other_programs = OtherProgram.all.map { |p| [p.title, p.obj_key] }
      kpcc_programs + other_programs
    end

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
    # Get the slot on at the requested time
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
      slot = self.where("start_time < end_time and " \
        "start_time <= :time and end_time > :time", time: second)
        .order("start_time").first
      return slot if slot.present?
      
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
      slot = self.where("start_time > end_time and " \
        "(start_time <= :time or end_time > :time)", time: second)
        .order("start_time").first
    end
    
    #--------------
    # Block of schedule
    def block(start_time, length)
      end_time        = start_time + length
      different_weeks = end_time.wday < start_time.wday
      order           = "start_time"

      args = { 
        :start_time   => start_time.second_of_week,
        :end_time     => end_time.second_of_week
      }
      
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
        slots = self.where("end_time > :start_time and " \
          "start_time < :end_time", args)
          .order(order).to_a

      else
        before = self.where("end_time < start_time or " \
          "end_time > :start_time", args).order(order).to_a

        after  = self.where("start_time < :end_time", args)
          .order(order).to_a
        
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


  attr_writer \
    :program_obj_key,
    :start_time_string,
    :end_time_string

  def program_obj_key
    @program_obj_key || self.program.try(:obj_key)
  end

  def start_time_string
    @start_time_string || time_input(:starts_at)
  end

  def end_time_string
    @end_time_string || time_input(:ends_at)
  end


  #--------------
  # Methods to return real Time objects.
  def starts_at
    @starts_at ||= at_time(:start_time)
  end

  def ends_at
    @ends_at ||= at_time(:end_time)
  end

  #-----------------
  # The day as an integer
  def day
    self.starts_at.wday
  end

  #-----------------
  # The day as a string (eg. "Monday")
  def day_word
    Date::DAYNAMES[day]
  end
  
  
  #--------------
  # This will only be true for one slot...
  # But we need to check.
  def split_weeks?
    self.end_time < self.start_time
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
    
    if !self.split_weeks?
      self.start_time <= now && self.end_time > now
    else
      now >= self.start_time || now < self.end_time
    end
  end
  
  #--------------
  # Has the slot not yet started this week?
  def upcoming?
    Time.now.second_of_week < self.start_time
  end

  
  #--------------
  # This is for the listen live JS.
  # TODO Move it somewhere else.
  def json
    {
      :start => self.starts_at.to_i,
      :end   => self.ends_at.to_i,
      :title => self.program.title,
      :link  => self.program.public_path
    }
  end


  def title
    self.program.title
  end
  
  def public_url
    self.program.public_url
  end

  #--------------

  private

  def set_program_from_obj_key
    self.program = Outpost.obj_by_key(self.program_obj_key)
  end
  
  def time_strings_can_be_parsed
    [:start_time_string, :end_time_string].each do |attribute|
      if m = self.send(attribute).match(INPUT_FORMAT)
        if !days_into_week(m[:day])
          self.errors.add(attribute, 
            "'#{m[:day]}' isn't recognized as a day name.")
        end
      else
        self.errors.add(attribute, 
          "can't be parsed. Format: Wednesday 14:00")
      end
    end
  end

  def set_times_from_input_strings
    self.start_time   = parse_time_string(self.start_time_string)
    self.end_time     = parse_time_string(self.end_time_string)
  end

  def parse_time_string(time_string)
    time_string.match(INPUT_FORMAT) do |m|
      total_seconds(days_into_week(m[:day]), m[:hour], m[:min])
    end
  end

  #--------------
  # If the slot is now or upcoming, use
  # this week's date. If it's past, use
  # next week's date.
  def at_time(attribute)
    if seconds = self.send(attribute)
      time = RecurringScheduleSlot.as_time(seconds)
      time += 1.week if self.past?
      time
    end
  end

  def total_seconds(day, hour, minute)
    (day.to_i * 24 * 60 * 60) +
    (hour.to_i * 60 * 60) +
    (minute.to_i * 60)
  end

  def time_input(attribute)
    if time = self.send(attribute)
      time.strftime("%A %H:%M")
    end
  end

  def days_into_week(day_string)
    DAYS_INTO_WEEK[day_string.downcase.to_sym]
  end
end
