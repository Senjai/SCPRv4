module WP
  class Attachment < Post
    XPATH = "//item/wp:post_type[text()='attachment']/.."
    self.list_fields = Post.list_fields
    
    class << self
      # Return false so they're all taken
      def invalid_item(node)
        false
      end
    end
  end
end
