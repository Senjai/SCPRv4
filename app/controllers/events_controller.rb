class EventsController < ApplicationController
  def index
    @upcoming_events = Event.upcoming.limit(4)
    @closest_event = @upcoming_events.first
    @future_events = @upcoming_events[1..-1]
    @past_events = Event.past.limit(3)
    
    @tweets = Twitter.user_timeline("KPCCForum").first(5) if Rails.env == 'production'
  end
  
  def show
  end
end