require "spec_helper"

describe WidgetsHelper do
  let(:object) { create :blog_entry }
  
  describe "#article_meta_for" do # Should we test this a little more? It's really just a partial that renders a bunch of other partials, so maybe not. 
    it "renders the article_meta partial" do
      article_meta_for(object).should match "article-meta"
    end
    
    it "doesn't render anything if content isn't present" do
      article_meta_for(nil).should be_nil
    end
  end
  
  
  describe "#comment_count_link_for" do
    it "renders a link to the comments" do
      comment_count_link_for(object).should match "href"
      comment_count_link_for(object).should match object.link_path(anchor: "comments")
    end
    
    it "shows the number of comments fort the object" do
      object.comment_count = "10"
      comment_count_link_for(object).should match /Comments \(10\)/
    end
    
    it "uses the class passed in and appends comment-link" do
      comment_count_link_for(object, class: "other").should match "comment_link other"
    end
      
    it "doesn't render anything if content isn't present" do
      comment_count_link_for(nil).should be_nil
    end
  end
  
  
  describe "#comment_count_for" do
    it "renders the comment_count partial" do
      comment_count_for(object).should_not be_nil
      comment_count_for(object).should match "comment-count"
    end
    
    it "shows the number of comments" do
      object.comment_count = 13
      comment_count_for(object).should match "#{object.comment_count}"
    end
    
    it "has a link to the comments" do
      comment_count_for(object).should match object.link_path(anchor: "comments")
    end
    
    it "doesn't render anything if object is not present" do
      comment_count_for(nil).should be_nil
    end
    
    it "passes in the cssClass" do
      comment_count_for(object, cssClass: "someclass").should match "someclass"
    end
  end
  
  
  describe "#featured_comment" do
    pending
  end
  
  
  describe "#recent_posts" do
    it "doesn't render anything if content isn't present" do
      recent_posts(nil).should be_nil
    end
  end
  
  
  describe "#comments_for" do
    it "renders the comments partial" do
      comments_for(object).should match 'comments'
    end
    
    it "passes along the cssClass" do
      comments_for(object, cssClass: "special_class").should match "special_class"
    end
  end


  describe "#related_content_for" do
    it "renders the related_articles partial" do
      
    end
  end
  
  
  describe "#social_tools_for" do
    it "renders the partial" do
      social_tools_for(object).should_not be_blank
    end
    
    it "uses the path passed in" do
      social_tools_for(object, path: "/some/path").should match "/some/path"
    end
    
    it "uses the cssClass passed in" do
      social_tools_for(object, cssClass: "someClass").should match "someClass"
    end
  end
end