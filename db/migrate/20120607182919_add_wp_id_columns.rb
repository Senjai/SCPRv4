class AddWpIdColumns < ActiveRecord::Migration
  def up
    add_column :blogs_entry, :wp_id, :integer
  end

  def down
    remove_column :blogs_entry, :wp_id
  end
end
