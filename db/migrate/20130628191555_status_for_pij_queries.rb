class StatusForPijQueries < ActiveRecord::Migration
  def up
    add_column :pij_query, :status, :integer
    add_index :pij_query, :status

    PijQuery.all.each do |query|
      if query.is_active?
        query.update_column :status, PijQuery::STATUS_LIVE
      else
        query.update_column :status, PijQuery::STATUS_DRAFT
      end
    end

    remove_column :pij_query, :is_active
  end

  def down
    add_column :pij_query, :is_active, :boolean
    remove_column :pij_query, :status
  end
end
