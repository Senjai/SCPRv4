class Admin::HomeController < Admin::BaseController
  def index
    breadcrumb "Dashboard", admin_root_path
    
    # Get the latest activity
    @current_user_activities = @admin_user.activities.order("created_at desc").limit(10)
    @latest_activities       = Secretary::Version.order("created_at desc").where("user_id != ?", @admin_user.id).limit(10)
  end
  
  #------------------------
  
  def not_found
    render_error(404)
  end

  def trigger_error
    raise Exception, "This is a test error. It works (or does it?)"
  end
end
