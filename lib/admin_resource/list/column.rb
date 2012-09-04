module AdminResource
  module List
    class Column
      attr_accessor :attribute, :linked, :helper, :position
      attr_writer :header
    
      def initialize(attribute, position, attributes={})
        @attribute = attribute
        @position  = position
       
        @header    = attributes[:header]
        @helper    = attributes[:helper]
        @linked    = !!attributes[:linked] # force boolean
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
