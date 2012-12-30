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
        @records = resource_class.order("#{resource_class.table_name}.#{resource_class.admin.list.order}").page(params[:page]).per(resource_class.admin.list.per_page)        
      end

      #-----------------
      
      def filter_records
        if params[:filter].is_a? Hash
          params[:filter].each do |attribute, value|
            next if value.blank?
            scope = "filtered_by_#{attribute}"

            if @records.klass.respond_to? scope
              @records = @records.send(scope, value)
            else
              @records = @records.where(attribute => value)
            end
          end
        end
      end
    end # Callbacks
  end # Controller
end # AdminResource
