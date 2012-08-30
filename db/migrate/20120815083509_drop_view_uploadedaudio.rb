class DropViewUploadedaudio < ActiveRecord::Migration
  def up
    execute("drop view rails_media_uploadedaudio")
  end
  
  def down
    execute("
      create view rails_media_uploadedaudio as 
      select 
        l.id,
        l.object_id as content_id,
        m.class_name as content_type,
        l.mp3_file,
        l.description,
        l.source,
        l.allow_download,
        l.sort_order
      from 
        media_uploadedaudio as l, 
        rails_content_map as m 
      where l.content_type_id = m.id
    ")
  end
end
