##
# AdminResource::List::Base

module AdminResource
  module List
    class Base
      attr_accessor :admin, :order # Must be a string since it gets passed directly to ActiveRecord
      attr_reader :columns, :filters, :per_page
      
      def initialize(admin, attributes = {})
        @admin    = admin
        @columns  = []
        @filters  = []
        
        self.order    = attributes[:order]    || List::DEFAULTS[:order]
        self.per_page = attributes[:per_page] || List::DEFAULTS[:per_page]
      end
      
      #---------------
      
      def list_order(val)
        self.order = val
      end
      
      #---------------
      # Return nil if per_page is set to :all
      # So that pagination will not paginate
      def list_per_page(val)
        self.per_page = val
        
      end
      
      def per_page=(val)
        @per_page = val == :all ? nil : val.to_i
      end
      
      #---------------
      # This is the method that should be used to add columns
      # to a list, rather than directly creating a new Column
      #
      # Usage:
      #   define_list do
      #     column :name, header: "Full Name", display: :display_full_name
      #     column :user, header: "Associated User", display: proc { self.user.name }
      #   end
      #
      # Options:
      # * header:     (str) The title of the column, displayed in the table header.
      #               Defaults to attribute.titleize
      #
      # * display:    (sym or Proc) How to display this attribute.
      #               If symbol, should be the name of a method in AdminListHelper
      #               If Proc, gets run as an instance of the class.
      #               See AdminListHelper for more info.
      #
      def column(attribute, options={})
        column = Column.new(attribute, self, options)
        self.columns.push column
        column
      end
      
      #---------------
      
      def filter(attribute, options={})
        filter = Filter.new(attribute, self, options)
        self.filters.push filter
        filter
      end
    end
  end
end
