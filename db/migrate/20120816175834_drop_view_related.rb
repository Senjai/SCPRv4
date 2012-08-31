class DropViewRelated < ActiveRecord::Migration
  def up
    execute("drop view rails_media_related")
  end
  
  def down
    execute("
      create view rails_media_related as 
      select 
        l.id,
        l.object_id as content_id,
        m.class_name as content_type,
        l.rel_object_id as related_id,
        r.class_name as related_type,        
        l.flag
      from 
        media_related as l
      left join
        rails_content_map as m on m.id = l.content_type_id
      left join
        rails_content_map as r on r.id = l.rel_content_type_id
    ")
    
  end
end
