##
# Filter
#
module AdminResource
  module List
    class Filter
      attr_accessor :attribute, :collection
      
      #---------------
      
      def initialize(attribute, list, options={})
        @attribute  = attribute
        @collection = options[:collection]
        @list       = list
      end
    end
  end
end
