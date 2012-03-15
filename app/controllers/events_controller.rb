class EventsController < ApplicationController
  def index
    @upcoming_events = Event.upcoming.limit(4)
    @closest_event = @upcoming_events.first
    @future_events = @upcoming_events[1..-1]
    @past_events = Event.past.limit(3)
  end
  
  def show
  end
end