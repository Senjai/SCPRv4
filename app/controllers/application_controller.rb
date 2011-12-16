class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_session
  
  helper_method :current_user
  
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
