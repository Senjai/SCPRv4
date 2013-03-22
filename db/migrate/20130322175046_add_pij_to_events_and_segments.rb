class AddPijToEventsAndSegments < ActiveRecord::Migration
  def change
    #add_column :shows_segment, :is_from_pij, :boolean
    add_column :events, :is_from_pij, :boolean 
  end
end
