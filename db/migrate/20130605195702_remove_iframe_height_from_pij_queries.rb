class RemoveIframeHeightFromPijQueries < ActiveRecord::Migration
  def up
    remove_column :pij_query, :form_height
  end

  def down
    add_column :pij_query, :form_height, :integer
  end
end
