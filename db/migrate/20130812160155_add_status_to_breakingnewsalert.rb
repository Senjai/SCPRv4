class AddStatusToBreakingnewsalert < ActiveRecord::Migration
  def change
    add_column :layout_breakingnewsalert, :status, :integer
    add_index :layout_breakingnewsalert, [:status, :created_at]
  end
end
