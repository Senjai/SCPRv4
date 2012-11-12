## 
# AdminResource::Helpers::Controller
#
module AdminResource
  module Helpers
    module Controller
      extend ActiveSupport::Concern
      
      included do
        if self < ActionController::Base
          helper_method :resource_class
        end
      end

      #------------------
      
      def resource_class
        @resource_class ||= AdminResource::Helpers::Naming.to_class(params[:controller])
      end
      
      #------------------
      
      def index
        @list = resource_class.admin.list
        respond_with :admin, @records
      end

      #------------------

      def new
        breadcrumb "New"
        @record = resource_class.new
        respond_with :admin, @record
      end

      #------------------

      def show
        respond_with :admin, @record
      end

      #------------------

      def edit
        breadcrumb "Edit"
        respond_with :admin, @record
      end

      #------------------

      def create
        @record = resource_class.new(params[resource_class.singular_route_key])
        if @record.save
          notice "Saved #{@record.simple_title}"
          respond_with :admin, @record, location: location
        else
          breadcrumb "New"
          render :new
        end
      end

      #------------------

      def update
        if @record.update_attributes(params[@record.class.singular_route_key])
          notice "Saved #{@record.simple_title}"
          respond_with :admin, @record, location: location
        else
          breadcrumb "Edit"
          render :edit
        end
      end

      #------------------

      def destroy
        @record.destroy
        notice "Deleted #{@record.simple_title}"
        respond_with :admin, @record
      end
      
      #--------------
      
      private
      
      def notice(message)
        flash[:notice] = message if request.format.html?
      end
      
      #--------------
      
      def location
        case params[:commit_action]
        when "edit" then @record.admin_edit_path
        when "new"  then @record.class.admin_new_path
        else @record.class.admin_index_path
        end
      end
    end # Controller
  end # Helpers
end # AdminResource
