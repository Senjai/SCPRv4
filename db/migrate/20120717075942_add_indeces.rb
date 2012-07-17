class AddIndeces < ActiveRecord::Migration
  def up
    add_index :assethost_contentasset, :content_id
    add_index :assethost_contentasset, [:content_type, :content_id]
    
    add_index :contentbase_contentbyline, :content_id
    add_index :contentbase_contentbyline, [:content_type, :content_id]
  end

  def down
    remove_index :contentbase_contentbyline, column: [:content_type, :content_id]
    remove_index :contentbase_contentbyline, :content_id
    
    remove_index :assethost_contentasset, column: [:content_type, :content_id]
    remove_index :assethost_contentasset, :content_id
  end
end
