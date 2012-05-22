class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_session, :set_up_finders
  
  #----------
  
  helper_method :current_user
  helper_method :admin_user
  
  def current_user
    @current_user
  end
  
  def admin_user
    @admin_user
  end
  
  def require_admin
    if @admin_user
      return true
    else
      redirect_to '/admin/' and return
    end
  end
  
  #----------
  
  private
  
  def set_up_finders
    @g_upcoming_events_forum = Event.published.upcoming.forum.limit(4)
    @g_upcoming_events_sponsored = Event.published.upcoming.sponsored
    @latest_videos = VideoShell.published.limit(5)
    
    # FIXME: Isn't there a way to do this without hardcoding the table name in the where clause?
    @g_latest_blogs_news = BlogEntry.published.joins(:blog).where("blogs_blog.is_news = true").order("published_at desc")
    @g_latest_blogs_arts = BlogEntry.published.joins(:blog).where("blogs_blog.is_news = false").order("published_at desc")
  end
  
  #----------
  
  def check_session
    if session['_auth_user_id']
      begin
        @admin_user = AdminUser.active.find(session['_auth_user_id'])
      rescue
        @admin_user = nil
        session['_auth_user_id'] = nil
      end
    end
    
    if session[:user_id]
      begin
        @current_user = UserProfile.find(session[:user_id])
      rescue
        @current_user = nil
        session[:user_id] = nil
      end
    end
  end
end
