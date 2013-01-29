require "spec_helper"

describe Category do  
  describe "content" do
    it "returns an empty array if the page * per_page is greater than Thinking Sphinx's max_matches" do
      category = create :category_news
      category.content(101, 10).should be_blank
    end
  end

  #--------------------
  
  describe "featured_candidates" do
    pending
  end
end
