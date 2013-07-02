class Outpost::RecurringScheduleRulesController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.per_page = 200
    
    l.column :program, display: ->(r) { r.program.title }
    l.column :schedule, header: "Rule", display: ->(r) { r.schedule.to_s }
  end
end
