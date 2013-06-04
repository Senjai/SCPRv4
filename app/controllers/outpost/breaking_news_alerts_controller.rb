class Outpost::BreakingNewsAlertsController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "created_at"
    l.default_sort_mode = "desc"
    
    l.column :headline
    l.column :alert_type, header: "Type", display: ->(r) { BreakingNewsAlert::ALERT_TYPES[r.alert_type] }
    l.column :visible, header: "Visible?"
    l.column :is_published, header: "Published?"
    l.column :email_sent, header: "Email Sent?"
    l.column :created_at, sortable: true, default_sort_mode: "desc"

    l.filter :alert_type, title: "Type", collection: -> { BreakingNewsAlert.types_select_collection }
    l.filter :is_published, title: "Published?", collection: :boolean
    l.filter :email_sent, title: "Email Sent?", collection: :boolean
  end
end
