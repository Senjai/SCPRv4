class Outpost::RecurringScheduleSlotsController < Outpost::ResourceController
  outpost_controller
  #----------------
  # Outpost
  self.model = RecurringScheduleSlot

  define_list do |l|
    l.default_order = "start_time"
    l.default_sort_mode = "asc"
    l.per_page = :all
    
    l.column :program, display: proc { self.program.title }
    l.column :start_time, header: "Start Time", display: proc { "#{self.day_word}, #{self.format_time(:starts_at)}" }, sortable: true, default_sort_mode: "asc"
    l.column :end_time, header: "End Time", display: proc { "#{self.day_word}, #{self.format_time(:ends_at)}" }
  end
end
