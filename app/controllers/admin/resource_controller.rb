##
# ResourceController
#
# Adds in some default behavior for resources in the CMS.
class Admin::ResourceController < Admin::BaseController
  include AdminResource::Controller
  
  before_filter :authorize_resource
  before_filter :extend_breadcrumbs_with_resource_root
  before_filter :add_user_id_to_params, only: [:create, :update]
  
  respond_to :html, :json, :js

  #-----------------
  
  def extend_breadcrumbs_with_resource_root
    breadcrumb resource_class.to_title.pluralize, resource_class.admin_index_path
  end

  #-----------------
  # For Secretary
  def add_user_id_to_params
    params[resource_class.singular_route_key].merge!(logged_user_id: admin_user.id)
  end
  
  #-----------------
  
  private
  
  def authorize_resource
    authorize!(resource_class)
  end
end
