module WP
  class Category < Node
    XPATH = "/rss/channel/wp:category"
    
    # -------------------
    # Class
    
    class << self

      # -------------------      
      # Elements
      
      def elements(doc)
        @elements ||= doc.xpath(XPATH)
      end
    end
    
    
    # -------------------
    # Instance
    
    # -------------------
    # Convenience Methods
    
    def id
      term_id
    end
    
    def to_title
      cat_name
    end
  end
end