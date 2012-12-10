module AdminResource
  module Controller
    module Callbacks
      extend ActiveSupport::Concern
      
      #-----------------

      def get_record
        @record = resource_class.find(params[:id])
      end

      #-----------------

      def get_records
        @records = resource_class.order(resource_class.admin.list.order).page(params[:page]).per(resource_class.admin.list.per_page)
      end
    end # Callbacks
  end # Controller
end # AdminResource
