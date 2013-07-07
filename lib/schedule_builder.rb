# A light wrapper around IceCube::Schedule to handle our
# specific use-case.
#
# If you want more control (passing in hour_of_day, duration, etc),
# then just use IceCube::Schedule directly.
#
# This was originally built to handle and process the form inputs
# (like start_time "11:00"), but can also be useful in tests or 
# in callbacks.
class ScheduleBuilder
  DEFAULT_SECOND_OF_MINUTE = 0


  class << self
    def build_schedule(attributes={})
      self.new(attributes).build_schedule
    end
  end


  attr_accessor :interval, :days
  attr_reader :start_time, :end_time


  def initialize(attributes={})
    self.interval     = attributes[:interval]
    self.days         = attributes[:days]
    self.start_time   = attributes[:start_time].to_s
    self.end_time     = attributes[:end_time].to_s
  end


  def start_time=(string)
    @start_time_parts = parse_time_string(string)
    @start_time = string
  end

  def end_time=(string)
    @end_time_parts = parse_time_string(string)
    @end_time = string
  end


  def duration
    start_time_seconds = calculate_seconds(@start_time_parts)
    end_time_seconds   = calculate_seconds(@end_time_parts)

    return 0 unless start_time_seconds && end_time_seconds

    if start_time_seconds <= end_time_seconds
      end_time_seconds - start_time_seconds
    else
      1.day - start_time_seconds + end_time_seconds
    end
  end


  def build_schedule
    return nil unless @days && @interval && @start_time_parts.present?

    IceCube::Schedule.new do |s|
      s.duration = duration

      s.rrule(IceCube::Rule.weekly
        .day(@days)
        .hour_of_day(@start_time_parts[0])
        .minute_of_hour(@start_time_parts[1])
        .second_of_minute(DEFAULT_SECOND_OF_MINUTE)
        .interval(@interval)
      )
    end
  end


  private

  def parse_time_string(string)
    string.to_s.split(":").map(&:to_i)
  end

  def calculate_seconds(time_parts)
    return nil if time_parts.empty?
    time_parts[0].to_i * 60 * 60 + time_parts[1].to_i * 60
  end
end
