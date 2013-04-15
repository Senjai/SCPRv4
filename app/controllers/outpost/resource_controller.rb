##
# ResourceController
#
# Adds in some default behavior for resources in the CMS.
class Outpost::ResourceController < Outpost::BaseController
  include Concern::Controller::Searchable

  before_filter :extend_breadcrumbs_with_resource_root
  before_filter :add_user_id_to_params, only: [:create, :update]
  before_filter :set_preview, only: [:preview]

  respond_to :html, :json, :js

  #-----------------
  
  def extend_breadcrumbs_with_resource_root
    breadcrumb model.to_title.pluralize, model.admin_index_path
  end

  #-----------------
  # For Secretary
  def add_user_id_to_params
    if model.has_secretary?
      params[model.singular_route_key].merge!(logged_user_id: current_user.id)
    end
  end
  
  #-----------------

  def set_preview
    @PREVIEW = true
  end
end
