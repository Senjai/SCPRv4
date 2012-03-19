class EventsController < ApplicationController
  respond_to :html
  
  def index
    @events = Event.upcoming.paginate(page: params[:page], per_page: 10)
    if params[:list] == "forum"
      @events = @events.forum
    elsif params[:list] == "sponsored"
      @events = @events.sponsored
    end
    respond_with @events  
  end
  
  def archive
    @events = Event.forum.past.paginate(page: params[:page], per_page: 10)
  end
  
  def show
    # will handle a single event
  end
  
  def forum
    @upcoming_events = Event.upcoming.limit(4)
    @closest_event = @upcoming_events.first
    @future_events = @upcoming_events[1..-1]
    @past_events = Event.past.limit(3)
    render layout: 'forum'
  end
end