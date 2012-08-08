class UpdateViewForEvents < ActiveRecord::Migration
  def up
    execute("
    create or replace 
    SQL SECURITY INVOKER 
    view rails_events_event as 
    select 
      id,headline,slug,body,
      type as etype,
      sponsor,sponsor_link,starts_at,ends_at,is_all_day,
      location_name,location_link,rsvp_link,
      show_map,address_1,address_2,city,state,zip_code,
      created_at,modified_at,kpcc_event,for_program,
      archive_description,audio,is_published, show_comments, teaser,
      event_asset_scheme
    from 
      events_event
    ")
  end

  def down
    execute("
    create or replace 
    SQL SECURITY INVOKER 
    view rails_events_event as 
    select 
      id,headline,slug,body,
      type as etype,
      sponsor,sponsor_link,starts_at,ends_at,is_all_day,
      location_name,location_link,rsvp_link,
      show_map,address_1,address_2,city,state,zip_code,
      created_at,modified_at,kpcc_event,for_program,
      archive_description,audio,is_published, show_comments, teaser
    from 
      events_event
    ")
  end
end
