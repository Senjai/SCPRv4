class Admin::ResourceController < Admin::BaseController
  include AdminResource::Controller::Actions
  
  before_filter :authorize_resource
  before_filter :get_record, only: [:show, :edit, :update, :destroy]
  before_filter :get_records, only: :index
  before_filter :extend_breadcrumbs_with_resource_root
  before_filter :add_user_id_to_params, only: [:create, :update]
    
  respond_to :html, :json, :js

  #-----------------
  
  def get_record
    @record = resource_class.find(params[:id])
  end

  #-----------------
  
  def get_records
    @records = resource_class.order(resource_class.admin.list.order).page(params[:page]).per(resource_class.admin.list.per_page || 99999) # Temporary until Kaminari fixes this?
  end

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
