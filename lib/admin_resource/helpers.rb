module AdminResource
  module Helpers
    def to_class(resource)
      resource.singularize.demodulize.parameterize.underscore.camelize.constantize
    end

    def to_title(resource)
      resource.singularize.demodulize.titleize
    end
    
    def to_param(resource)
      resource.singularize.demodulize.parameterize.underscore.to_sym
    end

    def path_helper(resource)
      Rails.application.routes.url_helpers.send("admin_#{resource.demodulize.tableize}_path")
    end
  end
end
