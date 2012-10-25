## 
# AdminResource::Helpers::Controller

module AdminResource
  module Helpers
    module Controller
      extend ActiveSupport::Concern
      
      included do
        helper_method :resource_class

        # These can be used as normal helpers
        # Needs to be included manually
        #
        # These helpers expect a controller param, such as 'admin/news_stories'
        # "admin/news_stories" => NewsStory
        def to_class(controller)
          controller.singularize.camelize.demodulize.constantize
        end
    
        # Extract the controller from a full path
        # Not a good method, assumes /r/ namespace
        # Need to fix it
        # "/r/admin/news_stories/edit/" #=> "admin/news_stories"
        def extract_controller(path)
          path.split("/")[2..3].join("/")
        end
      
        def resource_class
          @resource_class ||= to_class(params[:controller])
        end
      end
    end # Controller
  end # Helpers
end # AdminResource
