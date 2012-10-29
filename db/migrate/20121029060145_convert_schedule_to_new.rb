class OldSchedule < ActiveRecord::Base
  self.table_name = "schedule_program"
end

class ConvertScheduleToNew < ActiveRecord::Migration
  def up
    OldSchedule.order("start_time").all.each do |os|
      ns = RecurringScheduleSlot.new
      
      if os.other_program_id.present?
        ns.program_type = "OtherProgram"
        ns.program_id = os.other_program_id
      elsif os.kpcc_program_id.present?
        ns.program_type = "KpccProgram"
        ns.program_id = os.kpcc_program_id
      end
      
      start_time = Time.new(2000, 1, 2 + os.day, os.start_time.hour, os.start_time.min, 0)
      end_time   = Time.new(2000, 1, 2 + os.day, os.end_time.hour, os.end_time.min, 0)

      if end_time.hour == 0 && end_time.min == 0
        end_time += 1.day
      end
      
      ns.start_time = start_time.second_of_week
      ns.end_time   = end_time.second_of_week
      
      ns.save!
      $stdout.puts "saved schedule: #{ns.attributes}"
    end
  end

  def down
    RecurringScheduleSlot.delete_all
  end
end
