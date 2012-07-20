class UpdateBlogsCreatedAt < ActiveRecord::Migration
  def up
    Blog.local.all.each do |blog|
      if earliest = blog.entries.published.last
        blog.update_attributes(created_at: earliest.published_at)
      end
    end
  end

  def down
    # Nothing to do
  end
end
