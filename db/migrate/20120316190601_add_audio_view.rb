class AddAudioView < ActiveRecord::Migration
  def change
    execute("
      create or replace 
      SQL SECURITY INVOKER 
      view rails_media_audio as 
      select 
        l.id,
        l.object_id as content_id,
        m.class_name as content_type,
        l.mp3,
        l.description,
        l.byline,
        l.enco_number,
        l.enco_date,
        l.position,
        l.duration,
        l.size
      from 
        media_audio as l, 
        rails_content_map as m 
      where l.content_type_id = m.id
    ")
  end
end
