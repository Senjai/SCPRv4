##
# Concern::Controller::Searchable
#
# Requirements:
# * This model for this class (`model`) is indexed by Sphinx
# * This controller has been bootstrapped by Outpost
#
module Concern
  module Controller
    module Searchable
      # Action
      def search
        breadcrumb "Search"
        
        @records = model.search(params[:query], {
          :page     => params[:page] || 1,
          :per_page => 50 # More results = higher efficiency
          }.merge(search_params)
        )
      end

      #-----------------

      private

      def search_params
        @search_params ||= {
          :order       => order.to_sym,
          :sort_mode   => sort_mode.to_sym
        }
      end
    end
  end
end
