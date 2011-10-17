class AddMediaLinksView < ActiveRecord::Migration
  def up
    execute("
      create view rails_media_link as 
      select 
        l.id,
        l.object_id as content_id,
        m.class_name as content_type,
        l.title,
        l.link,
        l.link_type,
        l.sort_order
      from 
        media_link as l, 
        rails_content_map as m 
      where l.content_type_id = m.id
    ")
  end

  def down
    execute("drop view rails_media_link")
  end
end
