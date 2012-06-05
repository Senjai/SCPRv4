class Admin::SessionsController < Admin::BaseController
  skip_before_filter :require_admin, except: :destroy
  respond_to :html
  
  def new
    redirect_to admin_root_path if admin_user
  end
  
  def create
    if user = AdminUser.authenticate(params[:username], params[:password])
      cookies[:auth_token] = user.auth_token
      redirect_to admin_root_path, notice: "Logged in."
    else
      flash.now[:alert] = "Invalid login information."
      render 'new'
    end    
  end
  
  def destroy
    @admin_user = nil
    cookies.delete(:auth_token)
    redirect_to admin_login_path, notice: "Logged Out."
  end
end