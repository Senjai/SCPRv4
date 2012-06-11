class AddMATables < ActiveRecord::Migration
  def change
    create_table  :wp_posts do |t|
      t.integer   :wp_post_id,
      t.string    :title,
      t.string    :slug,
      t.text      :content,
      t.integer   :wp_author_id,
      t.integer   :merc_author_id,
      t.datetime  :published_at,
      t.integer   :status,
      t.string    :blog_asset_scheme,
      t.integer   :comment_count,
      t.string    :short_headline,
      t.string    :teaser,
      t.integer   :dsq_thread_id
    end
    
    create_table :wp_attachments do |t|
    end
    
    create_table :wp_authors do |t|
      t.integer :wp_author_id,
      t.integer :merc_author_id,
      t.string  :name
    end
    
    create_table :wp_tags do |t|
      t.string :name,
      t.string :slug
    end
    
    create_table :wp_tags_posts do |t|
      t.integer :post_id,
      t.integer :tag_id
    end
    
    create_table :wp_categories do |t|
    end
  end
end