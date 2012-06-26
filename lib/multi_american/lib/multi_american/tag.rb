module WP
  class Tag < Node
    XPATH = "/rss/channel/wp:tag"
    
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
      tag_name
    end
  end
end