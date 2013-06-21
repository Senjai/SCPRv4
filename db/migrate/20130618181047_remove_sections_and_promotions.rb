class RemoveSectionsAndPromotions < ActiveRecord::Migration
  def up
    drop_table :sections
    drop_table :promotions
    drop_table :section_blogs
    drop_table :section_promotions
    drop_table :section_categories
  end

  def down
    create_table "sections", :force => true do |t|
      t.string   "title"
      t.string   "slug"
      t.datetime "created_at",          :null => false
      t.datetime "updated_at",          :null => false
      t.integer  "missed_it_bucket_id"
    end

    add_index "sections", ["missed_it_bucket_id"], :name => "index_sections_on_missed_it_bucket_id"

    create_table "section_blogs", :force => true do |t|
      t.integer  "section_id"
      t.integer  "blog_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "section_blogs", ["blog_id"], :name => "index_section_blogs_on_blog_id"
    add_index "section_blogs", ["section_id"], :name => "index_section_blogs_on_section_id"

    create_table "section_categories", :force => true do |t|
      t.integer  "section_id"
      t.integer  "category_id"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "section_categories", ["category_id"], :name => "index_section_categories_on_category_id"
    add_index "section_categories", ["section_id"], :name => "index_section_categories_on_section_id"

    create_table "section_promotions", :force => true do |t|
      t.integer  "section_id"
      t.integer  "promotion_id"
      t.datetime "created_at",   :null => false
      t.datetime "updated_at",   :null => false
    end

    add_index "section_promotions", ["promotion_id"], :name => "index_section_promotions_on_promotion_id"
    add_index "section_promotions", ["section_id"], :name => "index_section_promotions_on_section_id"

    create_table "promotions", :force => true do |t|
      t.string   "title"
      t.string   "url"
      t.integer  "asset_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end
  end
end
