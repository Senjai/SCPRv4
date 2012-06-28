class AddWpIdColumns < ActiveRecord::Migration
  def up
    add_column :blogs_entry, :wp_id, :integer
    add_column :blogs_blogcategory, :wp_id, :integer
    add_column :taggit_tag, :wp_id, :integer
  end

  def down
    remove_column :blogs_entry, :wp_id
  end
end
