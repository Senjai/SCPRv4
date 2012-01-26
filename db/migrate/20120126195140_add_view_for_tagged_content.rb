class AddViewForTaggedContent < ActiveRecord::Migration
  def up
    execute("
        create view rails_taggit_taggeditem as 
        select
        	c.id,
          c.tag_id,
        	c.object_id as content_id,
          m.class_name as content_type
        from 
        	taggit_taggeditem as c
        left join
            rails_content_map as m on m.id = c.content_type_id
    ")
  end

  def down
    execute("drop view rails_taggit_taggeditem")
  end
end
