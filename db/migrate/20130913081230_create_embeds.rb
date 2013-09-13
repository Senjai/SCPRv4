class CreateEmbeds < ActiveRecord::Migration
  def change
    create_table :embeds do |t|
      t.string :title
      t.string :content_type
      t.integer :content_id
      t.string :url
      t.timestamps
    end

    add_index :embeds, [:content_type, :content_id]
  end
end
