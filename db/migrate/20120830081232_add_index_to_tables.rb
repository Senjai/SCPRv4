class AddIndexToTables < ActiveRecord::Migration
  INDEX_TABLES = %w{ 
      media_audio media_link media_related contentbase_contentalarm 
      contentbase_featuredcomment contentbase_homepagecontent 
      contentbase_misseditcontent contentbase_contentcategory
      taggit_taggeditem ascertainment_ascertainmentrecord 
    }
    
  def up
    INDEX_TABLES.each do |table|
      add_index table,  :content_id
      add_index table,  [:content_type, :content_id]
    end

    add_index "media_related",  :related_id
    add_index "media_related",  [:related_type, :related_id]
  end
  
  def down
    INDEX_TABLES.each do |table|
      remove_index table,  :content_id
      remove_index table,  [:content_type, :content_id]
    end

    remove_index "media_related",  :related_id
    remove_index "media_related",  [:related_type, :related_id]
  end
end
