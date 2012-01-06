class Schedule < ActiveRecord::Base
  set_table_name 'schedule_program'

  belongs_to :kpcc_program, :class_name => "KpccProgram"
  belongs_to :other_program, :class_name => "OtherProgram"

  def self.on_now
    # find program matching today's week day and current time
    program = self.where("day = ? and start_time < ?",Date.today.wday,Time.now.to_s(:time)).order("start_time desc").first
    
    return program
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
  
end