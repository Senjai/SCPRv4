##
# Routes helpers
#
# Provides easy access to any object's admin paths,
# and any class's admin paths
#
module AdminResource
  module Helpers
    module Routes
      def self.included(base)
        base.extend ClassMethods
      end
      
      #--------------
      
      module ClassMethods
        # /admin/blog_entries
        def admin_new_path
          @admin_new_path ||= Rails.application.routes.url_helpers.send("new_admin_#{self.singular_route_key}_path")
        end
        
        def admin_index_path
          @admin_index_path ||= Rails.application.routes.url_helpers.send("admin_#{self.route_key}_path")
        end
      end
      
      #--------------
      # /admin/blog_entries/20/edit
      def admin_edit_path
        @admin_edit_path ||= Rails.application.routes.url_helpers.send("edit_admin_#{self.class.singular_route_key}_path", self.id)
      end

      #--------------
      # /admin/blog_entries/20
      def admin_show_path
        @admin_show_path ||= Rails.application.routes.url_helpers.send("admin_#{self.class.singular_route_key}_path", self.id)
      end
      
      #-------------
      # Uses self.class::ROUTE_KEY to generated
      # the front-end path to this object
      # If an object doesn't have a front-end path,
      # do not defined a ROUTE_KEY
      def link_path(options={})
        @link_path ||= begin
          if self.route_hash.present? and defined?(self.class::ROUTE_KEY)
            Rails.application.routes.url_helpers.send("#{self.class::ROUTE_KEY}_path", options.merge!(route_hash))
          end
        end
      end
      
      def route_hash
        {}
      end
            
      def remote_link_path(options={})
        "http://#{Rails.application.default_url_options[:host]}#{self.link_path(options)}"
      end
    end
  end
end
