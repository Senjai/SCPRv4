##
# Outpost::List::Base

module Outpost
  module List
    class Base
      def initialize(model)
        @model = model
        
        @columns = []
        @fields  = []
        
        @default_order     = List::DEFAULT_ORDER
        @default_sort_mode = List::DEFAULT_SORT_MODE
        @per_page          = List::DEFAULT_PER_PAGE

        yield if block_given?
      end
      
      #---------------

      attr_accessor :default_order
      alias_method :list_default_order, :default_order=

      #---------------

      attr_accessor :default_sort_mode
      alias_method :list_default_sort_mode, :default_sort_mode=
      
      #---------------
      # Return nil if per_page is set to :all
      # So that pagination will not paginate
      attr_reader :per_page

      def per_page=(val)
        @per_page = (val == :all ? nil : val.to_i)
      end

      alias_method :list_per_page, :per_page=

      #---------------

      def columns
        @columns ||= default_columns
      end

      #---------------

      def fields
        @fields ||= default_fields
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
        @columns.push column
        column
      end
      
      #---------------
      
      def filter(attribute, options={})
        filter = Filter.new(attribute, self, options)
        @filters.push filter
        filter
      end

      #---------------

      private

      def default_columns
        @model.column_names - Outpost.config.excluded_list_columns
      end

      def default_fields
        @model.column_names - Outpost.config.excluded_form_fields
      end
    end
  end
end
