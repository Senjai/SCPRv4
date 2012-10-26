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
        
        # These can be used as normal helpers
        # Needs to be included manually
        #
        # These helpers expect a controller param, such as 'admin/news_stories'
        # "admin/news_stories" => NewsStory
        def to_class(controller)
          controller.singularize.camelize.demodulize.constantize
        end
      
        def resource_class
          @resource_class ||= to_class(params[:controller])
        end
      end
    end # Controller
  end # Helpers
end # AdminResource
