module WP
  class Topic < Post
    XPATH = "//item/wp:post_type[text()='topic']/.."
    
    class << self
      def elements(doc)
        doc.xpath(XPATH)
      end
    end
  end
end
