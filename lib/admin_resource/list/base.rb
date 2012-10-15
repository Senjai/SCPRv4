##
# AdminResource::List::Base

module AdminResource
  module List
    class Base
      attr_accessor :order # Must be a string since it gets passed directly to ActiveRecord
      attr_reader :columns, :per_page
      
      def initialize(attributes={})
        @columns      = []
        @order        = attributes[:order]    || List::DEFAULTS[:order]
        self.per_page = attributes[:per_page] || List::DEFAULTS[:per_page]
      end

      #---------------
      # This is the method that should be used to add columns
      # to a list, rather than directly creating a new Column
      #
      # Usage:
      #   define_list do
      #     column "name", header: "Full Name", helper: "display_full_name", linked: true
      #   end
      #
      # Options:
      # * header:     (str) The title of the column, displayed in the table header.
      #               Defaults to attribute.titleize
      #
      # * helper:     (sym or Proc) The helper method to use to display this attribute.
      #               See AdminListHelper for how to set that up.
      #
      # * linked:     (bool) Whether or not to link this attribute to the edit page
      #
      def column(attribute, options={})
        column = Column.new(attribute, self, options)
        self.columns.push column
        column
      end
      
      # Return the columns in this list which are linked
      # This is useful for determining if we need to inject a link into the list
      def linked_columns
        @linked_columns ||= self.columns.select { |c| c.linked? }
      end
    
      #---------------
      
      # per_page
      # Return nil if per_page is set to :all
      # So that pagination will not paginate
      def per_page=(val)
        @per_page = val == :all ? nil : val.to_i
      end
    end
  end
end
