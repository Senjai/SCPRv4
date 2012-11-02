class ListenController < ApplicationController
  def index
    # grab eight hours worth of schedule, starting now
    @schedule = Schedule.block(Time.now, 8.hours)
    
    # grab our homepage stories
    @homepage = Homepage.published.first
    
    render layout: false
  end
end
