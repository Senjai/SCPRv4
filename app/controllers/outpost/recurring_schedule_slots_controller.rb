class Outpost::RecurringScheduleSlotsController < Outpost::ResourceController
  outpost_controller
  #----------------
  # Outpost
  self.model = RecurringScheduleSlot

  define_list do |l|
    l.default_order = "start_time"
    l.default_sort_mode = "asc"
    l.per_page = :all
    
    l.column :program, display: ->(r) { r.program.title }
    l.column :start_time, header: "Start Time", display: ->(r) { "#{r.day_word}, #{r.format_time(:starts_at)}" }, sortable: true, default_sort_mode: "asc"
    l.column :end_time, header: "End Time", display: ->(r) { "#{r.day_word}, #{r.format_time(:ends_at)}" }
  end
end
