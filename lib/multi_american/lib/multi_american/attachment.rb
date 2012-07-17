module WP
  class Attachment < Node
    XPATH = "//item/wp:post_type[text()='attachment']/.."
    administrate
    self.list_fields = PostBase.list_fields

    class << self
      def invalid_child(node)
        (Builder.is_postmeta(node) and 
          node.at_xpath("./wp:meta_value").content == "{{unknown}}") ||
        super
      end
      
      # Return false so they're all taken
      def invalid_item(node)
        false
      end
      
      def importable
        false
      end
      
      def nested_attributes
        [:@postmeta]
      end
    end
    
    # ------------------
    # Instance
    
    def initialize(element)
      @builder = { postmeta: [] }
      super(element)
    end
    
    def sorter
      Time.parse(self.pubDate)
    end
    
    def to_title
      title
    end
    
    def id
      post_id.to_i
    end
  end
end
