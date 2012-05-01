class ListenController < ApplicationController
  
  def index
    # grab eight hours worth of schedule, starting now
    @schedule = Schedule.at :time => Time.now(), :hours => 8
    
    # grab our homepage stories
    @homepage = Homepage.published.first
    
    render :layout => false
  end
  
end