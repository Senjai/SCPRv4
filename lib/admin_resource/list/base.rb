module AdminResource
  module List
    class Base
      DEFAULTS = {
        order:            "id desc",
        per_page:         25,
        excluded_fields:  ["id", "created_at", "updated_at"]
      }
    
      def initialize(attributes={})
        self.order    = attributes[:order]    || DEFAULTS[:order]
        self.per_page = attributes[:per_page] || DEFAULTS[:per_page]
        @columns  = []
      end

      #---------------
    
      attr_accessor :order

      #---------------
    
      def columns
        @columns || []
      end
    
      def column(attribute, options={})
        self.columns.push Column.new(attribute, @columns.size, options)
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
