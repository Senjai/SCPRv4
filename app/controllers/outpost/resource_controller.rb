##
# ResourceController
#
# Adds in some default behavior for resources in the CMS.
class Outpost::ResourceController < Outpost::BaseController
  include Concern::Controller::Searchable
  
  before_filter :get_record, only: [:show, :edit, :update, :destroy, :activity]
  before_filter :get_records, only: [:index]
  before_filter :authorize_resource
  before_filter :filter_records, only: [:index]
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

  #-----------------

  def render_preview_validation_errors(record)
    render "/outpost/shared/_preview_errors", layout: "outpost/minimal", locals: { record: record }
  end
end
