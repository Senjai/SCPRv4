class DropViewHomepagecontent < ActiveRecord::Migration
  def up
    execute("drop view rails_layout_homepagecontent")
  end
  
  def down
    execute("
      create view rails_layout_homepagecontent as 
      select 
        l.id,
        l.homepage_id,
        l.object_id as content_id,
        m.class_name as content_type,
        l.position
      from 
        layout_homepagecontent as l, 
        rails_content_map as m 
      where l.content_type_id = m.id
    ")
  end
end
