module Outpost
  module Controller
    module Callbacks
      extend ActiveSupport::Concern
      
      private

      #-----------------

      def get_record
        @record = model.find(params[:id])
      end

      #-----------------

      def get_records
        @records = model.order("#{model.table_name}.#{self.list.order}").page(params[:page]).per(self.list.per_page)
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
end # Outpost
