module AdminResource
  module List
    class Base
      DEFAULTS = {
        order:            "id desc",
        per_page:         25,
        excluded_fields:  ["id", "created_at", "updated_at"]
      }

      attr_accessor :order
      attr_reader :columns
      
      def initialize(attributes={})
        @columns      = []        
        self.order    = attributes[:order]    || DEFAULTS[:order]
        self.per_page = attributes[:per_page] || DEFAULTS[:per_page]
      end

      #---------------
      # This is the method that should be used to add columns
      # to a list, rather than directly creating a new Column
      #
      # Usage:
      #   admin.define_list do |list|
      #     list.column "name", header: "Full Name", helper: "display_full_name", linked: true
      #   end
      #
      # Options:
      # * header:     (str) The title of the column, displayed in the table header.
      #               Defaults to attribute.titleize
      #
      # * helper:     (sym) The helper method to use to display this attribute.
      #               See AdminListHelper for how to set that up.
      #
      # * linked:     (bool) Whether or not to link this attribute to the edit page
      #
      def column(attribute, options={})
        column = Column.new(attribute, self, options)
        self.columns.push column
        column
      end
    
      #---------------
    
      def linked_columns
        @linked_columns ||= self.columns.select { |c| c.linked? }
      end
    
      #---------------
    
      def per_page
        # Need to check if defined, because we might want to
        # pass `nil` to limit (specifying no limit).
        defined?(@per_page) ? @per_page : DEFAULTS[:per_page]
      end
    
      def per_page=(val)
        if val == "all"
          per_page = nil
        else
          per_page = val.to_i
        end
      
        @per_page = per_page
      end
    end
  end
end
