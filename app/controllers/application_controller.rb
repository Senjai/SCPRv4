class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_session
  
  before_filter :masthead_content
  
  helper_method :current_user
  
  def masthead_content
    @events = Event.where("is_published = ? AND starts_at > ? AND etype != ? AND etype != ?", 1, Time.now, "spon", "pick").order("starts_at ASC").limit(2)
  end
  
  def current_user
    @current_user
  end
  
  private
  def check_session
    if session[:user_id]
      @current_user = UserProfile.find(session[:user_id])
    end
  rescue
    @current_user = nil
  end
end
