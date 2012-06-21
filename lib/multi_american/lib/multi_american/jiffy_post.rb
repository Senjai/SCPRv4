module WP
  class JiffyPost < Post
    XPATH = "//item/wp:post_type[text()='jiffypost']/.."
    
    class << self
      def elements(doc)
        doc.xpath(XPATH)
      end
    end
  end
end
