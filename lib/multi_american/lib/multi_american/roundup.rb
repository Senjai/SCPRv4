module WP
  class Roundup < PostBase
    XPATH = "//item/wp:post_type[text()='roundup']/.."    
    self.list_fields = PostBase.list_fields
  end
end