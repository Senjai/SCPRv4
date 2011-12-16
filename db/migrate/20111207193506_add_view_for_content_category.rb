class AddViewForContentCategory < ActiveRecord::Migration
  def up
    execute("
      create view rails_contentbase_contentcategory as 
      select
      	c.id,
        c.category_id,
      	c.object_id as content_id,
        m.class_name as content_type
      from 
      	contentbase_contentcategory as c
      left join
          rails_content_map as m on m.id = c.content_type_id
    ")
    
  end

  def down
    execute("drop view rails_contentbase_contentcategory")
  end
end
