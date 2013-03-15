class Outpost::HomeController < Outpost::BaseController
  def index
    breadcrumb "Dashboard", outpost_root_path
    
    # Get the latest activity
    @current_user_activities = current_user.activities
      .order("created_at desc").limit(10)
    @latest_activities       = Secretary::Version.order("created_at desc")
      .where("user_id != ?", current_user.id).limit(10)
  end
  
  #------------------------
  
  def not_found
    render_error(404, ActionController::RoutingError.new("Not Found"))
  end

  def trigger_error
    raise StandardError, "This is a test error. It works (or does it?)"
  end
end
