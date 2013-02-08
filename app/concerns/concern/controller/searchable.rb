##
# Concern::Controller::Searchable
#
# Requires that "resource_class" is defined, and that
# that class is a Newsroom'd class, and that it has
# a Sphinx index defined.
#
module Concern
  module Controller
    module Searchable
      # Action
      def search
        breadcrumb resource_class.to_title, resource_class.admin_index_path, "Search"

        @records = resource_class.search(params[:query], {
          :page     => params[:page] || 1,
          :per_page => 50
          }.merge(search_params)
        )

        @list = resource_class.admin.list
      end

      private

      def search_params
        @search_params ||= {}
      end
    end
  end
end
