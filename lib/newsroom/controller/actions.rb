##
# Newsroom::Controller::Actions
#
# This provides basic CRUD actions for you to include into any
# controller that you want to behave like an resource management
# area.
#
module Newsroom
  module Controller
    module Actions
      extend ActiveSupport::Concern
      
      included do
        include Newsroom::Controller::Callbacks
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
        redirect_to @record.admin_edit_path
      end

      #------------------

      def edit
        breadcrumb "Edit", nil, @record.to_title
        respond_with :admin, @record
      end

      #------------------

      def create
        @record = resource_class.new(params[resource_class.singular_route_key])
        if @record.save
          notice "Saved #{@record.simple_title}"
          respond_with :admin, @record, location: requested_location
        else
          breadcrumb "New"
          render :new
        end
      end

      #------------------

      def update
        if @record.update_attributes(params[@record.class.singular_route_key])
          notice "Saved #{@record.simple_title}"
          respond_with :admin, @record, location: requested_location
        else
          breadcrumb "Edit", nil, @record.to_title
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
      
      #--------------
      
      def requested_location
        case params[:commit_action]
        when "edit" then @record.admin_edit_path
        when "new"  then @record.class.admin_new_path
        else @record.class.admin_index_path
        end
      end
    end # Actions
  end # Controller
end # Newsroom
