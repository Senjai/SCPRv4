class ChangeSegmentOrderToPosition < ActiveRecord::Migration
  def change
    rename_column :shows_rundown, :segment_order, :position
  end
end
