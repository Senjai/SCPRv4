class AddViewForHomepageContent < ActiveRecord::Migration
  def up
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

  def down
    execute("drop view rails_layout_homepagecontent")
  end
end
