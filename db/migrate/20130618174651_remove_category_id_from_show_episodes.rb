class RemoveCategoryIdFromShowEpisodes < ActiveRecord::Migration
  def up
    remove_column :shows_episode, :category_id
  end

  def down
    add_column :shows_episode, :category_id, :integer
  end
end
