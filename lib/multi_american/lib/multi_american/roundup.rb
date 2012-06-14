module WP
  class Roundup < Post
    XPATH = "//item/wp:post_type[text()='roundup']/.."
    
  end
end