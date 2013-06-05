class AddPinQueryIdToPijQueries < ActiveRecord::Migration
  def change
    add_column :pij_query, :pin_query_id, :string
  end
end
