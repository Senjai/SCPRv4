class Admin::AdminUsersController < Admin::ResourceController
  # Override this method from Admin::ResourceController
  # Users should always be able to see and update their
  # own profile.
  def authorize_resource
    if admin_user == @record && %w{show edit update}.include?(action_name)
      return true
    end
    
    super
  end
end
