module MultiAmerican
  class Attachment < Node
    XPATH = "//item/wp:post_type[text()='attachment']/.."

    administrate do |admin|      
      admin.define_list do |list|
        list.column "id",         header: "WP-ID"
        list.column "post_type"
        list.column "title",      linked: true,   helper: :display_or_fallback
        list.column "post_name",  header: "Slug"
        list.column "pubDate"
        list.column "status"
      end
    end
    
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
