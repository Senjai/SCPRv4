module WP
  class JiffyPost < PostBase
    XPATH = "//item/wp:post_type[text()='jiffypost']/.."      
    self.list_fields = PostBase.list_fields
  end
end
