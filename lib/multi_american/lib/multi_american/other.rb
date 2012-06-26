module WP
  class Other < Node
    registered = %w{ post attachment jiffypost nav_menu_item roundup topic}.map { |x| "not(text()='#{x}')" }
    XPATH = "//item/wp:post_type[#{registered.join(" and ")}]/..  "
    
    administrate!
    self.list_fields = [
      ['post_type']
    ]
    
    # -------------------
    # Class
    
    class << self

      # -------------------      
      # Elements
      
      def elements(doc)
        @elements ||= doc.xpath(XPATH)
      end
      
      def column_names
        @elements.first.attributes
      end
      
      def nested_attributes
        [:@postmeta]
      end
    end
    
    
    # -------------------
    # Instance
    
    def initialize(element)
      @builder = { postmeta: [] }
      super(element)
    end
    
    # -------------------
    # Convenience Methods
    
    def id
      post_id
    end
  end
end
