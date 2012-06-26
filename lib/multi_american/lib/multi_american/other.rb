module WP
  class Other < Node
    registered = %w{ post attachment jiffyopost nav_menu_item roundup topic}.map { |x| "text()='#{x}'" }
    XPATH = "//item/wp:post_type[not(#{registered.join(" and ")})]/.."
    
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
      attributes[0]
    end
  end
end
