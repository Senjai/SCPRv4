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
      t.integer :category_id
      t.string :short_url
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
      t.integer :category_id
      t.string :remote_url
      t.timestamps
    end
    
    create_table :test_class_posts, force: true do |t|
      t.string :headline
      t.string :short_headline
      t.text :body
      t.text :teaser
      t.string :slug
      t.datetime :published_at
      t.integer :status
      t.integer :category_id
      t.integer :program_id
      t.string :program_type
      t.timestamps
    end

    create_table :test_class_post_contents, force: true do |t|
      t.integer :post_id
      t.integer :position
      t.string :content_type
      t.integer :content_id
      t.timestamps
    end
    
    create_table :test_class_people, force: true do |t|
      t.string :name
      t.string :slug
      t.string :twitter_url
      t.timestamps
    end

    create_table :test_class_fake_audio, force: true do |t|
      t.string :path
      t.integer :status
      t.integer :duration
      t.integer :size
    end
  end
  
  def down
  end
end
