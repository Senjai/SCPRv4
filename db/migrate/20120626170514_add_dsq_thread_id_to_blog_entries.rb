class AddDsqThreadIdToBlogEntries < ActiveRecord::Migration
  def change
    add_column :blogs_entry, :dsq_thread_id, :integer
  end
end
