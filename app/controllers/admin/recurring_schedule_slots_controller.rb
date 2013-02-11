class Admin::RecurringScheduleSlotsController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = RecurringScheduleSlot

  define_list do
    list_per_page :all
    list_order "start_time"
    
    column :program, display: proc { self.program.title }
    column :starts_at, display: proc { self.format_time(:starts_at) }
    column :ends_at, display: proc { self.format_time(:ends_at) }
  end
end
