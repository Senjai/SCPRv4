class RemoveExpiresAtFromPijQueries < ActiveRecord::Migration
  def up
    PijQuery.where("expires_at is not null").each do |query|
      query.update_column(:is_active, false)
    end

    remove_column :pij_query, :expires_at
  end

  def down
    add_column :pij_query, :expires_at, :datetime
    add_index :pij_query, :expires_at
  end
end
