module WP
  class Topic < Post
    XPATH = "//item/wp:post_type[text()='topic']/.."
    self.list_fields = Post.list_fields
    
    class << self
      def elements(doc)
        doc.xpath(XPATH)
      end
    end
  end
end
