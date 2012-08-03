class DropViewForEvents < ActiveRecord::Migration
  def up
    execute("drop view rails_events_event")
  end

  def down
  end
end
