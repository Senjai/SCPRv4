module WP
  class Post < PostBase
    XPATH = "//item/wp:post_type[text()='post']/.."
    self.list_fields = PostBase.list_fields
    
    def style_rules!
      self.content = WP.view.simple_format(self.content, {}, sanitize: false)
      super
    end
  end
end
