class DropViewForFeaturedComments < ActiveRecord::Migration
  def up
    execute("drop view rails_contentbase_featuredcomment")
  end
  
  def down
    execute("
      create view rails_contentbase_featuredcomment as 
      select
      	c.id,
        c.bucket_id,
        c.status,
        c.published_at,
        c.username,
        c.excerpt,
      	c.object_id as content_id,
        m.class_name as content_type
      from 
      	contentbase_featuredcomment as c
      left join
          rails_content_map as m on m.id = c.content_type_id
    ")
  end
end
