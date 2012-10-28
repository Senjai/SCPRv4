##
# Authorize
#
# A convenience method to place in controllers
# that will check if the current user has permission
# to perform the requested action, and redirect them
# with a message if not.
#
module Authorize
  def authorize!(resource)
    include InstanceMethods
    before_filter { |c| c._authorize(c.admin_user, c.action_name, resource) }
  end
  
  module InstanceMethods
    protected
    def _authorize(user, action, resource)
      unless user.allowed_to?(action, resource)
        redirect_to admin_root_path, alert: "You don't have permission to do that." and return false
      end
    end
  end
end

ActionController::Base.send :extend, Authorize
