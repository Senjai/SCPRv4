class SetDefaultOnSendEmail < ActiveRecord::Migration
  def up
    change_column :layout_breakingnewsalert, :send_email, :boolean, default: false
  end

  def down
    change_column :layout_breakingnewsalert, :send_email, :boolean, default: nil
  end
end
