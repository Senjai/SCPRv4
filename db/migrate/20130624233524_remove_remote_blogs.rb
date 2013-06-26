class RemoveRemoteBlogs < ActiveRecord::Migration
  def up
    Blog.where(is_remote: true).destroy_all
    remove_column :blogs_blog, :is_remote
    remove_column :blogs_blog, :custom_url
  end

  def down
    add_column :blogs_blog, :is_remote, :boolean
    add_column :blogs_blog, :custom_url, :string
  end
end
