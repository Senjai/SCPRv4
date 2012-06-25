module WP
  class Author < Node
    XPATH = "/rss/channel/wp:author"

    # -------------------
    # Class
    
    class << self
      
      # -------------------      
      # Templates
      
      def index_template
        "authors_index"
      end
      
      def detail_template
        "obj_detail"
      end
      
      
      # -------------------      
      # Elements
      
      def elements(doc)
        @elements ||= doc.xpath(XPATH)
      end
    end
    
    
    # -------------------
    # Instance
    
    def id
      author_id
    end
    
  end
end