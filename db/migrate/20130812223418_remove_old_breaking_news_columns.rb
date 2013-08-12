class RemoveOldBreakingNewsColumns < ActiveRecord::Migration
  def up
    remove_column :layout_breakingnewsalert, :is_published
    remove_column :layout_breakingnewsalert, :alert_time
  end

  def down
    add_column :layout_breakingnewsalert, :is_published, :boolean
    add_column :layout_breakingnewsalert, :alert_time, :time
  end
end
