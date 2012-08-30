class AddIndexToTables < ActiveRecord::Migration
  INDEX_TABLES = %w{ 
      media_audio media_link media_related contentbase_contentalarm 
      contentbase_featuredcomment layout_homepagecontent 
      contentbase_misseditcontent contentbase_contentcategory
      taggit_taggeditem ascertainment_ascertainmentrecord 
    }
    
  def up
    INDEX_TABLES.each do |table|
      begin
        add_index table,  :content_id
        add_index table,  [:content_type, :content_id]
      rescue Exception => e
        puts "*** #{e}"
        next
      end
    end
    
    begin
      add_index "media_related",  :related_id
      add_index "media_related",  [:related_type, :related_id]
    rescue Exception => e
      puts "*** #{e}"
    end
  end
  
  def down
    INDEX_TABLES.each do |table|
      begin
        remove_index table,  :content_id
        remove_index table,  [:content_type, :content_id]
      rescue Exception => e
        puts "*** #{e}"
        next
      end
    end
    
    begin
      remove_index "media_related",  :related_id
      remove_index "media_related",  [:related_type, :related_id]
    rescue Exception => e
      puts "*** #{e}"
    end
  end
end
