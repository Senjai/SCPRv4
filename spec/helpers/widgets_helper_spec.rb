require "spec_helper"

describe WidgetsHelper do
  describe "#article_meta_for" do # Should we test this a little more? It's really just a partial that renders a bunch of other partials, so maybe not. 
    it "renders the article_meta partial" do
      object = create :show_segment # arbitrary object, should stub?
      article_meta_for(object).should_not be_blank
    end
  end
  
  describe "#comment_count_for" do
    pending
  end
  
  describe "#featured_comment" do
    pending
  end
  
  describe "#recent_posts" do
    pending
  end
  
  describe "#social_tools_for" do
    it "renders the partial" do
      object = create :blog_entry # arbitrary object, should stub?
      social_tools_for(object).should_not be_blank
    end
    
    it "uses the path passed in" do
      object = create :blog_entry
      social_tools_for(object, path: "/some/path").match("/some/path").should_not be_nil
    end
    
    it "uses the cssClass passed in" do
      object = create :blog_entry
      social_tools_for(object, cssClass: "someClass").match("someClass").should_not be_nil
    end
  end
end