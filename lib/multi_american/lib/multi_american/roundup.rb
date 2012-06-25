module WP
  class Roundup < Post
    XPATH = "//item/wp:post_type[text()='roundup']/.."
    
    class << self
      def elements(doc)
        doc.xpath(XPATH)
      end
    end
  end
end