class Admin::BreakingNewsAlertsController < Admin::ResourceController
  #-------------
  # Outpost
  self.model = BreakingNewsAlert

  define_list do
    column :headline
    column :alert_type, display: proc { BreakingNewsAlert::ALERT_TYPES[self.alert_type] }
    column :visible
    column :is_published
    column :email_sent
    column :created_at
  end
end
