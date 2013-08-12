class Outpost::BreakingNewsAlertsController < Outpost::ResourceController
  outpost_controller

  define_list do |l|
    l.default_order       = "created_at"
    l.default_sort_mode   = "desc"

    l.column :headline
    l.column :alert_type,
      :header     => "Type",
      :display    => ->(r) { BreakingNewsAlert::ALERT_TYPES[r.alert_type] }

    l.column :status
    l.column :visible, header: "Visible?"
    l.column :email_sent, header: "Emailed?"
    l.column :mobile_notification_sent, header: "Pushed?"
    l.column :created_at, sortable: true, default_sort_mode: "desc"


    l.filter :alert_type,
      :title        => "Type",
      :collection   => -> { BreakingNewsAlert.types_select_collection }

    l.filter :email_sent, title: "Email Sent?", collection: :boolean
    
    l.filter :mobile_notification_sent,
      :title        => "Mobile Notification Sent?",
      :collection   => :boolean
  end
end
