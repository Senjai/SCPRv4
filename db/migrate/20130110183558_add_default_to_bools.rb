class AddDefaultToBools < ActiveRecord::Migration
  def up
    change_column :blogs_entry, :is_from_pij, :boolean, :default => false
    change_column :news_story, :is_from_pij, :boolean, :default => false
  end
  
  def down
    change_column :blogs_entry, :is_from_pij, :boolean
    change_column :blogs_entry, :is_from_pij, :boolean
  end
end
