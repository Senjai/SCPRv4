class CreateAbstracts < ActiveRecord::Migration
  def change
    create_table :abstracts do |t|
      t.string :source
      t.string :url
      t.string :headline
      t.text :summary
      t.integer :category_id
      t.datetime :article_published_at
      t.timestamps
    end

    add_index :abstracts, :source
    add_index :abstracts, :category_id
  end
end
