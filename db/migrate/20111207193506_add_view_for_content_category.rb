class AddViewForContentCategory < ActiveRecord::Migration
  def up
    execute("
      create view rails_contentbase_contentcategory as 
      select
      	c.id,
        c.category_id,
      	c.object_id as content_id,
        m.class_name as content_type,
      	COALESCE(news_story.status,shows_segment.status,blogs_entry.status,contentbase_contentshell.status) as status,
      	COALESCE(news_story.published_at,shows_segment.created_at,blogs_entry.published_at,contentbase_contentshell.pub_at) as pub_date
      from 
      	contentbase_contentcategory as c
      left join
          rails_content_map as m on m.id = c.content_type_id
      left join
      	news_story 
      on
      	news_story.id = c.object_id
      	and c.content_type_id = 15
      left join
      	shows_segment
      on 
      	shows_segment.id = c.object_id
      	and c.content_type_id = 24
      left join
      	blogs_entry
      on
      	blogs_entry.id = c.object_id
      	and c.content_type_id = 44
      left join
        contentbase_contentshell
      on
        contentbase_contentshell.id = c.object_id
        and c.content_type_id = 115
    ")
    
  end

  def down
    execute("drop view rails_contentbase_contentcategory")
  end
end
