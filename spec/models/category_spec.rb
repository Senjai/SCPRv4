require "spec_helper"

describe Category do
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
      category.link_path(anchor: "comments").match("#comments").should_not be_nil
    end
  end
end