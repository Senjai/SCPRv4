class SetNullOnBoolFields < ActiveRecord::Migration
  def up
    change_column :layout_breakingnewsalert, :send_mobile_notification, :boolean, null: false
    change_column :layout_breakingnewsalert, :mobile_notification_sent, :boolean, null: false
  end

  def down
    change_column :layout_breakingnewsalert, :send_mobile_notification, :boolean, null: true
    change_column :layout_breakingnewsalert, :mobile_notification_sent, :boolean, null: true
  end
end
