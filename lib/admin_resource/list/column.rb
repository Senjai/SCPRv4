module AdminResource
  module List
    class Column
      attr_accessor :attribute, :linked, :display, :position, :list
      attr_writer :header
    
      def initialize(attribute, list, attributes={})
        @attribute = attribute.to_s
        @list      = list
        @position  = @list.columns.size

        @header  = attributes[:header]
        @display = attributes[:display]
        @linked  = !!attributes[:linked] # force boolean
      end
    
      def header
        @header ||= @attribute.titleize 
      end
    
      def linked?
        linked
      end
    end
  end
end
