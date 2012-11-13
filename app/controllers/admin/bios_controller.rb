class Admin::BiosController < Admin::ResourceController
  # Override this method from Admin::ResourceController
  # Users should always be able to see and update their
  # own bio.
  def authorize_resource
    if admin_user.bio.present? && 
      admin_user.bio == @record && 
      %w{show edit update}.include?(action_name)
      return true
    end
    
    super
  end
end
