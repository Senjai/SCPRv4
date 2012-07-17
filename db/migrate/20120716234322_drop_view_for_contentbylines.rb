class DropViewForContentbylines < ActiveRecord::Migration
  def up
    execute("drop view rails_contentbase_contentbyline")
  end
  
  def down
    execute("
      create view rails_contentbase_contentbyline as 
      select 
        l.id,
        l.user_id,
        l.name,
        l.object_id as content_id,
        m.class_name as content_type,
        l.role
      from 
        contentbase_contentbyline as l, 
        rails_content_map as m 
      where l.content_type_id = m.id
    ")
  end
end
