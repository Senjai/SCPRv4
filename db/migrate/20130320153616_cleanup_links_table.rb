class CleanupLinksTable < ActiveRecord::Migration
  def up
    rename_table :media_link, :related_links
    
    change_table :related_links do |t|
      t.rename :link, :url
      t.remove :sort_order
      t.remove :django_content_type_id
      t.remove_index name: "index_media_link_on_content_id"
      t.index :link_type
      t.change :title, :string, null: true
      t.change :url, :string, null: :true
      t.change :link_type, :string, null: true
      t.change :content_id, :integer, null: true
      t.change :content_type, :string
    end
  end

  def down
    change_table :related_links do |t|
      t.rename :url, :link
      t.column :django_content_type_id, :integer
      t.column :sort_order, :integer
      t.index :sort_order
      t.index :content_id
      t.index :django_content_type_id
      t.remove_index :link_type
    end

    rename_table :media_link, :related_links
  end
end
