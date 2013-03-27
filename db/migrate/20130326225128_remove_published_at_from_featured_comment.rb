class RemovePublishedAtFromFeaturedComment < ActiveRecord::Migration
  def up
    remove_column :contentbase_featuredcomment, :published_at
    add_index :contentbase_featuredcomment, :status
  end

  def down
    add_column :contentbase_featuredcomment, :published_at, :datetime
  end
end
