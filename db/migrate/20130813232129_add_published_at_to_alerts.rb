class AddPublishedAtToAlerts < ActiveRecord::Migration
  def change
    add_column :layout_breakingnewsalert, :published_at, :datetime
    remove_index :layout_breakingnewsalert, name: "index_layout_breakingnewsalert_on_status_and_created_at"
    add_index :layout_breakingnewsalert, [:status, :published_at]

    BreakingNewsAlert.published.each do |a|
      a.update_column(:published_at, a.created_at)
    end
  end
end
