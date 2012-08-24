module AdminResource
  module Helpers
    def self.to_class(resource)
      resource.singularize.demodulize.parameterize.underscore.camelize.constantize
    end

    def self.to_title(resource)
      resource.singularize.demodulize.titleize
    end
    
    def self.to_param(resource)
      resource.singularize.demodulize.parameterize.underscore.to_sym
    end

    def self.path_helper(resource)
      Rails.application.routes.url_helpers.send("admin_#{resource.demodulize.tableize}_path")
    end
  end
end