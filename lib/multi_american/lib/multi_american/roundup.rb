module WP
  class Roundup < Post
    XPATH = "//item/wp:post_type[text()='roundup']/.."
    self.list_fields = Post.list_fields
    
    class << self
      def elements(doc)
        doc.xpath(XPATH)
      end
    end
  end
end