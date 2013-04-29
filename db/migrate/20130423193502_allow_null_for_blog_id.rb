class AllowNullForBlogId < ActiveRecord::Migration
  def up
    change_column :blogs_entry, :blog_id, :integer, null: true
  end

  def down
    change_column :blogs_entry, :blog_id, :integer, null: false
  end
end
