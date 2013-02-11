##
# Concern::Controller::Searchable
#
# Requires that "model" is defined, and that
# that class is a Newsroom'd class, and that it has
# a Sphinx index defined.
#
module Concern
  module Controller
    module Searchable
      # Action
      def search
        breadcrumb model.to_title, model.admin_index_path, "Search"

        @records = model.search(params[:query], {
          :page     => params[:page] || 1,
          :per_page => 50
          }.merge(search_params)
        )
      end

      private

      def search_params
        @search_params ||= {}
      end
    end
  end
end
