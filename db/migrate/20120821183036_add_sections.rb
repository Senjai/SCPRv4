class AddSections < ActiveRecord::Migration
  def change
    create_table "sections" do |t|
      t.string "title"
      t.string "slug"
      t.timestamps
    end
    
    create_table "section_blogs" do |t|
      t.integer "section_id"
      t.integer "blog_id"
      t.timestamps
    end
    
    create_table "section_categories" do |t|
      t.integer "section_id"
      t.integer "category_id"
      t.timestamps
    end
  end
end
