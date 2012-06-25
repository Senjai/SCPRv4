module WP
  class Tag < Node
    XPATH = "/rss/channel/wp:tag"
    
    # -------------------
    # Class
    
    class << self
      def elements(doc)
        @elements ||= doc.xpath(XPATH)
      end
    end
    
    
    # -------------------
    # Instance
    
    def id
      term_id
    end
  end
end