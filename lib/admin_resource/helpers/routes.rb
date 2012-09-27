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
    end
  end
end
