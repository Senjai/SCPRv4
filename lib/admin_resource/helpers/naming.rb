##
# Naming
#
# Some naming helpers.
#
# Example:
#
#   AdminResource::Helpers::Naming.to_class("admin/news_stories")
#
module AdminResource
  module Helpers
    module Naming
      extend self
      
      # These helpers expect a controller param, 
      # such as 'admin/news_stories'
      # "admin/news_stories" => NewsStory
      def to_class(controller)
        controller.singularize.camelize.demodulize.constantize
      end
    end # Naming
  end # Helpers
end # AdminResource
