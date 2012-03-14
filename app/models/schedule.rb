class Schedule < ActiveRecord::Base
  self.table_name =  'schedule_program'

  belongs_to :kpcc_program, :class_name => "KpccProgram"
  belongs_to :other_program, :class_name => "OtherProgram"
  
  attr_accessor :_date

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
    
    # feed in our offset
    if start
      start._date = time.to_date
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
  
  def programme
    self.kpcc_program || self.other_program
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
  
  #----------
  
  def as_json(*args)
    stime = self.start_time
    etime = self.end_time
    
    if self._date
      stime = self._date.to_time + (self.start_time - self.start_time.to_date.to_time)
      
      if self.end_time < self.start_time
        etime = (self._date+1).to_time + (self.end_time - self.start_time.to_date.to_time)        
      else
        etime = self._date.to_time + (self.end_time - self.start_time.to_date.to_time)
      end
    end
    
    {
      :start  => stime.to_i,
      :end    => etime.to_i,
      :title  => self.programme.try(:title) || self.program
    }
  end
  
end