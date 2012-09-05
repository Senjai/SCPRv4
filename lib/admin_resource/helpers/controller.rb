module AdminResource
  module Helpers
    module Controller
      # These can be used as normal helpers
      # Needs to be included manually
      #
      # These helpers expect a controller param, such as 'admin/news_stories'
      #
      # "admin/news_stories" => "news_story"
      def singular_resource(controller)
        controller.singularize.camelize.demodulize.underscore
      end
  
      # "admin/news_stories" => NewsStory
      def to_class(controller)
        controller.singularize.camelize.demodulize.constantize
      end

      # "admin/news_stories" => "News Story"
      def to_title(controller)
        controller.singularize.camelize.demodulize.titleize
      end
    
      # Extract the controller from a full path
      # Not a good method, assumes /r/ namespace
      # Need to fix it
      # "/r/admin/news_stories/edit/" #=> "admin/news_stories"
      def extract_controller(path)
        path.split("/")[2..3].join("/")
      end
    end
  end
end
