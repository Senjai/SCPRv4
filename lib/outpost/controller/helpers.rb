## 
# Outpost::Controller::Helpers
#
module Outpost
  module Controller
    module Helpers
      extend ActiveSupport::Concern
      
      included do
        helper_method :sort_mode, :order
      end

      #------------------
      # Adds to the flash[:notice] object, only if
      # the request format is HTML.      
      def notice(message)
        flash[:notice] = message if request.format.html?
      end

      #------------------
      # Which attribute is doing the sorting
      attr_writer :order
      def order
        @order ||= begin
          if params[:order].present?
            params[:order]
          else
            list.default_order
          end
        end
      end

      #------------------
      # Get the sort model
      #
      # It will either be the requested sort mode, or if not available, 
      # then the table's default sort mode.
      attr_writer :sort_mode
      def sort_mode
        @sort_mode ||= begin
          if %w{ asc desc }.include?(params[:sort_mode])
            params[:sort_mode]
          else
            list.default_sort_mode
          end
        end
      end
    end # Helpers
  end # Controller
end # Outpost
