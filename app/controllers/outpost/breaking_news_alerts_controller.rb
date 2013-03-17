class Outpost::BreakingNewsAlertsController < Outpost::ResourceController
  #-------------
  # Outpost
  self.model = BreakingNewsAlert

  define_list do
    list_default_order "created_at"
    list_default_sort_mode "desc"
    
    column :headline
    column :alert_type, header: "Type", display: proc { BreakingNewsAlert::ALERT_TYPES[self.alert_type] }
    column :visible, header: "Visible?"
    column :is_published, header: "Published?"
    column :email_sent, header: "Email Sent?"
    column :created_at, sortable: true, default_sort_mode: "desc"

    filter :alert_type, title: "Type", collection: -> { BreakingNewsAlert.types_select_collection }
    filter :is_published, title: "Published?", collection: :boolean
    filter :email_sent, title: "Email Sent?", collection: :boolean
  end
end
