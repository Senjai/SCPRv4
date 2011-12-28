class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_session, :set_up_finders
  
  helper_method :current_user
  
  def current_user
    @current_user
  end
  
  private
  
  def set_up_finders
    @g_upcoming_events_forum = Event.published.upcoming_forum.limit(4)
  end
  
  def check_session
    if session[:user_id]
      @current_user = UserProfile.find(session[:user_id])
    end
  rescue
    @current_user = nil
  end
end
