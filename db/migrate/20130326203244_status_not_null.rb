class StatusNotNull < ActiveRecord::Migration
  def up
    change_column :layout_homepage, :status, :integer, null: false, default: 0
    change_column :news_story, :status, :integer, null: false, default: 0
    change_column :blogs_entry, :status, :integer, null: false, default: 0
    change_column :contentbase_videoshell, :status, :integer, null: false, default: 0
    change_column :contentbase_contentshell, :status, :integer, null: false, default: 0
    change_column :shows_episode, :status, :integer, null: false, default: 0
    change_column :shows_segment, :status, :integer, null: false, default: 0
    change_column :contentbase_featuredcomment, :status, :integer, null: false, default: 0
    change_column :events, :status, :integer, null: false, default: 0
    change_column :tickets, :status, :integer, null: false, default: 0
  end

  def down
  end
end
