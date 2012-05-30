class Admin::SessionsController < Admin::BaseController
  respond_to :html
  
  def new
  end
  
  def create
  end
  
  def destroy
    @admin_user = nil
    session['_auth_user_id'] = nil
    redirect_to admin_login_path
  end
end