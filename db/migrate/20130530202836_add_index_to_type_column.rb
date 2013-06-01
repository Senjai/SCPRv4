class AddIndexToTypeColumn < ActiveRecord::Migration
  def change
    add_index :media_audio, :type
    add_index :remote_articles, :type
  end
end
