class OldSchedule < ActiveRecord::Base; self.table_name = "schedule_program"; end

passed   = 0
failures = 0

RecurringScheduleSlot.order("start_time").all.each do |ns|
  s = nil
  
  if ns.program_type == "OtherProgram"
    s = OldSchedule.where(other_program_id: ns.program_id, day: ns.day, start_time: ns.starts_at, end_time: ns.ends_at)
  else
    s = OldSchedule.where(kpcc_program_id: ns.program_id, day: ns.day, start_time: ns.starts_at, end_time: ns.ends_at)
  end
  
  if s.present?
    puts "#{ns.id}: passed"
    passed += 1
  else
    puts "#{ns.id}: failed (#{ns.starts_at}, #{ns.ends_at}, #{ns.day})"
    failures += 1
  end
end

$stdout.puts "#{passed} Passed, #{failures} Failures"
