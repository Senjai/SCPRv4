require "spec_helper"

describe Category do
  describe "associations" do
    it { should belong_to :comment_bucket }
  end
  
  describe "#link_path" do
    it "can generate a link_path" do
      category = create :category_news
      category.link_path.should_not be_nil
    end
    
    it "accepts an options hash" do
      category = create :category_news
      category.link_path(anchor: "comments").should_not be_blank
    end
    
    it "merges in an options hash" do
      category = create :category_news
      category.link_path(anchor: "comments").should match "#comments"
    end
    
    it "does not override the hard-coded options" do
      category = create :category_news
      category.link_path(category: "wrong").should_not match "wrong"
    end
  end
  
  describe "content" do
    it "returns an empty array if the page * per_page is greater than Thinking Sphinx's max_matches" do
      category = create :category_news
      category.content(101, 10).should be_blank
    end
  end
end