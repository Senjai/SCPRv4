module WP
  class Topic < PostBase
    XPATH = "//item/wp:post_type[text()='topic']/.."
    self.list_fields = PostBase.list_fields
  end
end
