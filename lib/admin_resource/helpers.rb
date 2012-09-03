module AdminResource
  # These helpers expect to receive a controller parameter, 
  # such as "admin/new_stories"
  #
  module Helpers
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
    
    def extract_controller(path)
      path.split("/")[2..3].join("/")
    end
  end
end
