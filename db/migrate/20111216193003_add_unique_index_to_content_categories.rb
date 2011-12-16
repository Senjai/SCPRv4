class AddUniqueIndexToContentCategories < ActiveRecord::Migration
  def change
    add_index :contentbase_contentcategory, [:content_type_id,:object_id], :unique => true, :name => :content_key
  end
end
