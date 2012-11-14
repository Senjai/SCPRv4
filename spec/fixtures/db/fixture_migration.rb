class FixtureMigration < ActiveRecord::Migration
  def up
    create_table :test_class_stories, force: true do |t|
      t.string :headline
      t.string :short_headline
      t.text :body
      t.text :teaser
      t.string :slug
      t.datetime :published_at
      t.integer :status
      t.timestamps
    end
    
    create_table :test_class_remote_stories, force: true do |t|
      t.string :headline
      t.string :short_headline
      t.text :body
      t.text :teaser
      t.string :slug
      t.datetime :published_at
      t.integer :status
      t.timestamps
    end
    
    create_table :test_class_people, force: true do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end
  end
  
  def down
  end
end
