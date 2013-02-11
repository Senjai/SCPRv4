## 
# Outpost::Controller::Helpers
#
module Outpost
  module Controller
    module Helpers
      extend ActiveSupport::Concern
      
      included do
        helper_method :sort_mode, :order_attribute
      end

      #------------------
      # Adds to the flash[:notice] object, only if
      # the request format is HTML.      
      def notice(message)
        flash[:notice] = message if request.format.html?
      end

      #------------------
      # Which attribute is doing the sorting
      attr_writer :order_attribute
      def order_attribute
        @order_attribute ||= (params[:order].to_s if params[:order].present?)
      end

      #------------------
      # Figure out which sort mode to use.
      # If the current order is the one we're requesting,
      # then use either the column's default sort mode 
      # (if current_sort_mode is nil), or the requested
      # sort mode.
      attr_writer :sort_mode
      def sort_mode
        @sort_mode ||= (params[:sort_mode] if %w{ asc desc }.include?(params[:sort_mode]))
      end
    end # Helpers
  end # Controller
end # Outpost
