## 
# AdminResource::Controller::Helpers
#
module AdminResource
  module Controller
    module Helpers
      extend ActiveSupport::Concern
      
      included do
        if self < ActionController::Base
          helper_method :resource_class
        end
      end

      #------------------
      # Adds to the flash[:notice] object, only if
      # the request format is HTML.      
      def notice(message)
        flash[:notice] = message if request.format.html?
      end
      
      #-----------------
      
      def resource_class
        @resource_class ||= AdminResource::Helpers::Naming.to_class(params[:controller])
      end      
    end # Controller
  end # Helpers
end # AdminResource
