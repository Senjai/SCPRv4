require "spec_helper"

describe WidgetsHelper do
  let(:object) { create :blog_entry }
  
  describe "content_widget" do
    it "returns nil if object is not present" do
      content_widget("anything", nil).should be_nil
    end
    
    it "returns nil if object is not a contentbase" do
      content_widget("anything", "a string").should be_nil
    end
    
    it "uses the absolute path if the partial starts with a slash" do
      content_widget("/shared/widgets/facebook", object).should match /Like KPCC on Facebook/ # Need to figure out a better way to test this
    end
    
    it "looks in /shared/cwidgets if just the name of the partial is given" do
      content_widget("social_tools", object).should match /Share this\:/
    end
  end
  
  
  describe "#comment_count_for" do
    it "renders a link to the comments" do
      comment_count_for(object).should match "href"
      comment_count_for(object).should match object.link_path(anchor: "comments")
    end
    
    it "uses the class passed in and preserves the hard-coded classes" do
      comment_count = comment_count_for(object, class: "other")
      comment_count.should match /comment_link/
      comment_count.should match /social_disq/
      comment_count.should match /other/
    end
      
    it "doesn't render anything if content isn't present" do
      comment_count_for(nil).should be_nil
    end
    
    it "doesn't render anything if it doesn't respond to has_comments?" do
      comment_count_for(create :blog).should be_nil
    end
    
    it "doesn't render anything if has_comments? is false" do
      comment_count_for(create :content_shell).should be_nil
      blog_entry = create :blog_entry
      blog_entry.stub(:has_comments?) { false }
      comment_count_for(blog_entry).should be_nil
    end
  end
  
  
  describe "#comment_widget_for" do
    it "renders the comment_count partial" do
      comment_widget = comment_widget_for(object)
      comment_widget.should_not be_nil
      comment_widget.should match /comment-count/
    end
    
    it "has a link to the comments" do
      comment_widget_for(object).should match object.link_path(anchor: "comments")
    end
    
    it "doesn't render anything if object is not present" do
      comment_widget_for(nil).should be_nil
    end
    
    it "doesn't render anything if it doesn't respond to has_comments?" do
      comment_widget_for(create :blog).should be_nil
    end
    
    it "doesn't render anything if has_comments? is false" do
      comment_widget_for(create :content_shell).should be_nil
      blog_entry = create :blog_entry
      blog_entry.stub(:has_comments?) { false }
      comment_widget_for(blog_entry).should be_nil
    end
    
    it "passes in the cssClass" do
      comment_widget_for(object, cssClass: "someclass").should match /someclass/
    end
  end
  
  
  describe "#featured_comment" do
    pending
  end
  
  describe "#comments_for" do
    it "renders the comments partial" do
      comments_for(object).should match 'comments'
    end
    
    it "passes along the cssClass" do
      comments_for(object, cssClass: "special_class").should match "special_class"
    end
  end
end