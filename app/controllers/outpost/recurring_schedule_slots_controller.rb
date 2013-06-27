class Outpost::RecurringScheduleSlotsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order = "start_time"
    l.default_sort_mode = "asc"
    l.per_page = 200
    
    l.column :program, display: ->(r) { r.program.title }
    l.column :start_time, header: "Start Time", display: ->(r) { r.start_time_string }, sortable: true, default_sort_mode: "asc"
    l.column :end_time, header: "End Time", display: ->(r) { r.end_time_string }
  end
end
