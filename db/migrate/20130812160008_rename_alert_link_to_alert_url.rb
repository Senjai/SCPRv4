class RenameAlertLinkToAlertUrl < ActiveRecord::Migration
  def change
    rename_column :layout_breakingnewsalert, :alert_link, :alert_url
  end
end
