class AddFacebookAndTwitterToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs_blog, :facebook_url, :string
    add_column :blogs_blog, :twitter_handle, :string
  end
end
