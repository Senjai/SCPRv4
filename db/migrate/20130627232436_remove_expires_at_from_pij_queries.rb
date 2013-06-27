class RemoveExpiresAtFromPijQueries < ActiveRecord::Migration
  def up
    remove_column :pij_query, :expires_at
  end

  def down
    add_column :pij_query, :expires_at, :datetime
    add_index :pij_query, :expires_at
  end
end
