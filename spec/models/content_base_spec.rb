require 'spec_helper'

def symbolize(klass)
  klass.to_s.underscore.to_sym
end

describe ContentBase do
  ContentBase.content_classes.each do |c|
    describe c do      
      it "inherits from ContentBase" do
        object = build symbolize(c)
        object.is_a?(ContentBase).should be_true
      end
      
      describe "#published" do
        it "returns an ActiveRecord::Relation" do
          c.published.class.should eq ActiveRecord::Relation
        end
        
        it "can limit by published content" do
          published = create_list symbolize(c), 3, status: 5
          unpublished = create_list symbolize(c), 2, status: 4
          c.published.count.should eq 3
        end
      
        it "orders published content by published_at (or pub_at) descending" do
            objects = create_list symbolize(c), 3, status: 5
            c.published.first.should eq objects.last
            c.published.last.should eq objects.first
        end
      end
      
      it "must return a headline" do
        object = build symbolize(c)
        object.headline.should_not be_nil
      end
      
      it "must return a short_headline" do
        object = build symbolize(c)
        object.short_headline.should_not be_nil
      end
      
      it "must return a teaser" do
        object = build symbolize(c)
        object.teaser.should_not be_nil
      end
      
      it "must have a byline_elements attribute/method" do
        object = build symbolize(c)
        object.should respond_to :byline_elements
      end
      
      it "must return byline_elements as an array" do
        object = build symbolize(c)
        object.byline_elements.should be_a Array
      end
      
      describe "#link_path" do
        it "can generate a link_path" do
          object = create symbolize(c)
          object.link_path.should_not be_nil
        end
        
        it "accepts an options hash" do
          object = create symbolize(c)
          object.link_path(anchor: "comments").should_not be_blank
        end
        
        it "merges in an options hash unless it's a ContentShell" do
          object = create symbolize(c)
          if c == ContentShell
            object.link_path(anchor: "comments").match("#comments").should be_nil
          else  
            object.link_path(anchor: "comments").match("#comments").should_not be_nil
          end
        end
      end
      
      describe "#remote_link_path" do
        it "can generate a remote_link_path" do
          object = create symbolize(c)
          object.remote_link_path.should_not be_nil
        end
    
        it "points to scpr.org unless it's a ContentShell" do
          object = create symbolize(c)
          if c == ContentShell
            object.remote_link_path.match("http://www.scpr.org").should be_nil
          else
            object.remote_link_path.match("http://www.scpr.org").should_not be_nil
          end
        end
      end
    end
  end
end