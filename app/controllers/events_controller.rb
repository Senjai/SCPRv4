class EventsController < ApplicationController
  def index
    # FIXME This won't show events without an ends_at
    @scoped_events = Event.upcoming_and_current
    
    if params[:list] == "forum"
      @scoped_events = @scoped_events.forum
    elsif params[:list] == "sponsored"
      @scoped_events = @scoped_events.sponsored
    end
        
    @events = Event.sorted(@scoped_events).paginate(page: params[:page], per_page: 10)
  end
  
  def archive
    @events = Event.forum.past.paginate(page: params[:page] || 1, per_page: 10)
  end
  
  def show
    date         = Time.new(params[:year], params[:month], params[:day])
    @event       = Event.published.where(slug: params[:slug], starts_at: date..date.end_of_day).first!
    @more_events = Event.forum.upcoming.where("id != ?", @event.id).limit(2)
  end
  
  def forum
    @upcoming_events = Event.forum.upcoming_and_current.limit(3)
    @closest_event   = @upcoming_events.first
    @future_events   = @upcoming_events[1..-1]
    @past_events     = Event.forum.past.limit(3)
    render layout: 'forum'
  end
end
