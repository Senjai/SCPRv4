class Schedule < ActiveRecord::Base
  self.table_name =  'schedule_program'

  belongs_to :kpcc_program, :class_name => "KpccProgram"
  belongs_to :other_program, :class_name => "OtherProgram"

  def self.on_now
    # find program matching today's week day and current time
    program = self.where("day = ? and start_time < ?",Date.today.wday,Time.now.to_s(:time)).order("start_time desc").first
    
    return program
  end
  
  #----------
  
  # Returns the program on at the given time
  
  def self.on_at(time=Time.now())
    # first, try today
    start = self.where("day = ? and start_time < ?", time.wday, time.to_s(:time)).order("start_time desc").first
    
    if !start
      # if we didn't get a program today, we may be near midnight and we may need yesterday's last show
      start = self.where("day = ?", ( time.wday > 0 ? time.wday - 1 : 6 )).first
    end

    return start
  end
  
  #----------
  
  # Return a block of schedule, starting at the time given and lasting the duration fiven
  # Inputs:
  # * :time -- Time object for start time. Defaults to Time.now()
  # * :hours -- Integer for number of hours. Defaults to 4.
  
  def self.at(args={})
    time = args[:time] || Time.now()
    hours = args[:hours] || 4
    
    programs = []
    dur = 0

    # first, get what's on at our start time
    start = self.on_at(time)
    dur += (start.end_time - start.start_time)
    programs << start
    
    begin 
      s = programs[-1].up_next
      dur += (s.end_time - s.start_time)
      programs << s
    end while ( dur < hours * 60 * 60)
    
    return programs
  end
  
  #----------
  
  def programme
    self.kpcc_program || self.other_program
  end
  
  #----------
  
  def up_next
    # if our current program ends before the end of the day, we want whatever comes on next today
    if self.end_time.hour > 0
      # today...
      return self.class.where("day = ? and start_time >= ?",self.day,self.end_time.to_s(:time)).order("start_time asc").first
    else
      # ends at midnight, so we want the first show tomorrow
      return self.class.where("day = ?", ( self.day <= 5 ? self.day + 1 : 0 ) ).order("start_time asc").first
    end
  end
  
  #----------
  
  def as_json(*args)
    {
      :start  => self.start_time,
      :end    => self.end_time,
      :title  => self.programme.try(:title) || self.program
    }
  end
  
end