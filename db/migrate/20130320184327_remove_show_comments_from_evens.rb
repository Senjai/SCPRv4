class RemoveShowCommentsFromEvens < ActiveRecord::Migration
  def up
    rename_table :events_event, :events
    
    change_table :events do |t|
      t.remove :show_comments

      t.rename :sponsor_link, :sponsor_url
      t.rename :location_link, :location_url
      t.rename :rsvp_link, :rsvp_url
      t.rename :kpcc_event, :is_kpcc_event
      t.rename :etype, :event_type

      t.change :sponsor_url, :string
      t.change :location_url, :string
      t.change :rsvp_url, :string

      t.remove :old_audio
    end
  end

  def down
    rename_table :events, :events_event
    
    change_table :events_event do |t|
      t.column :show_comments, :boolean

      t.rename :sponsor_url, :sponsor_link
      t.rename :location_url, :location_link
      t.rename :rsvp_url, :rsvp_link
      t.rename :is_kpcc_event, :kpcc_event
      t.rename :event_type, :etype
      
      t.column :old_audio, :string
    end
  end
end
