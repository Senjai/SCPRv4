class Admin::RecurringScheduleSlotsController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = RecurringScheduleSlot

  define_list do
    list_default_order "start_time"
    list_default_sort_mode "asc"
    list_per_page :all
    
    column :program, display: proc { self.program.title }
    column :start_time, header: "Start Time", display: proc { "#{self.day_word}, #{self.format_time(:starts_at)}" }, sortable: true, default_sort_mode: "asc"
    column :end_time, header: "End Time", display: proc { "#{self.day_word}, #{self.format_time(:ends_at)}" }
  end
end
