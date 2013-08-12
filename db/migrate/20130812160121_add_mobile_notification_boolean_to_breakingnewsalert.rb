class AddMobileNotificationBooleanToBreakingnewsalert < ActiveRecord::Migration
  def change
    add_column :layout_breakingnewsalert, :mobile_notification_sent, :boolean
  end
end
