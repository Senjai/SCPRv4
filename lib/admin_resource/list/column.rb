module AdminResource
  module List
    class Column
      attr_accessor :attribute, :display, :position, :list, :quick_edit
      attr_writer :header
    
      def initialize(attribute, list, attributes={})
        @attribute = attribute.to_s
        @list      = list
        @position  = @list.columns.size

        @header     = attributes[:header]
        @display    = attributes[:display]
        @quick_edit = attributes[:quick_edit]
      end
    
      def header
        @header ||= @attribute.titleize 
      end
      
      #-----------------
      
      def quick_edit?
        !!self.quick_edit
      end
    end
  end
end
