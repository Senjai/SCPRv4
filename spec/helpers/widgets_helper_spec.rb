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
  
  describe "#comment_count_for" do
    it "renders a link to the comments" do
      comment_count_for(object).should match "href"
      comment_count_for(object).should match object.link_path(anchor: "comments")
    end
    
    it "shows the number of comments fort the object" do
      object.comment_count = "10"
      comment_count_for(object).should match /Comments \(10\)/
    end
    
    it "uses the class passed in and appends comment-link" do
      comment_count_for(object, class: "other").should match "comment_link other"
    end
      
    it "doesn't render anything if content isn't present" do
      comment_count_for(nil).should be_nil
    end
  end
  
  
  describe "#comment_widget_for" do
    it "renders the comment_count partial" do
      comment_widget_for(object).should_not be_nil
      comment_widget_for(object).should match "comment-count"
    end
    
    it "shows the number of comments" do
      object.comment_count = 13
      comment_widget_for(object).should match "#{object.comment_count}"
    end
    
    it "has a link to the comments" do
      comment_widget_for(object).should match object.link_path(anchor: "comments")
    end
    
    it "doesn't render anything if object is not present" do
      comment_widget_for(nil).should be_nil
    end
    
    it "passes in the cssClass" do
      comment_widget_for(object, cssClass: "someclass").should match "someclass"
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


  describe "#related_for" do
    it "does not render anything if object is not present" do
      related_for(nil).should be_nil
    end
    
    it "does not render anything if the object is not a ContentBase" do
      related_for(create :blog).should be_nil # blog is not a content bas
    end
    
    it "does not render anything if the object does not have any relations or links" do
      related_for(object).should be_blank
    end
    
    it "renders the related_content_and_links partial" do
      object_with_related_content = create :show_segment, brels_count: 1, frels_count: 1, link_count: 1
      object_with_related_content.brels.should be_present
      object_with_related_content.frels.should be_present
      object_with_related_content.related_links.should be_present
      related_partial = related_for(object_with_related_content)
      related_partial.should match "More from KPCC"
      related_partial.should match "Elsewhere on the Web"
    end
    
    it "shows the related content for the object" do
      object_with_related_content = create :show_segment, brels_count: 1, frels_count: 1
      related_partial = related_for(object_with_related_content)
      related_partial.should match object_with_related_content.frels.first.content.short_headline
      related_partial.should match object_with_related_content.brels.first.related.short_headline
    end
    
    it "shows the related links for the object" do
      object_with_related_content = create :show_segment, link_count: 1
      related_for(object_with_related_content).should match object_with_related_content.related_links.first.title
    end
  end
  
  
  describe "#social_tools_for" do
    it "doesn't render anything if the object is blank" do
      social_tools_for([]).should be_nil
    end
    
    it "doesn't render anything if the object is not a ContentBase" do
      social_tools_for(create :blog).should be_nil
    end
    
    it "renders the partial if the object is a ContentBase" do
      social_tools_for(object).should_not be_blank # object is a blog entry
    end
    
    it "uses the cssClass passed in" do
      social_tools_for(object, cssClass: "someClass").should match "someClass"
    end
  end
end