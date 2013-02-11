## 
# Outpost::Controller::Helpers
#
module Outpost
  module Controller
    module Helpers
      extend ActiveSupport::Concern
      
      included do
        helper_method :sort_mode
      end

      #------------------
      # Adds to the flash[:notice] object, only if
      # the request format is HTML.      
      def notice(message)
        flash[:notice] = message if request.format.html?
      end
      
      #------------------
      # Figure out which sort mode to use.
      # If the current order is the one we're requesting,
      # then use either the column's default sort mode 
      # (if current_sort_mode is nil), or the requested
      # sort mode.
      def sort_mode(column, order, current_sort_mode)
        if order == params[:order]
          case current_sort_mode
          when "asc"  then "desc"
          when "desc" then "asc"
          else column.default_sort_mode
          end
        else
          column.default_sort_mode
        end
      end
    end # Helpers
  end # Controller
end # Outpost
