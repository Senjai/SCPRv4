class RemoveQueryUrlFromPijQueries < ActiveRecord::Migration
  def up
    remove_column :pij_query, :query_url
  end

  def down
    add_column :pij_query, :query_url, :string
  end
end
