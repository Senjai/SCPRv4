require 'spec_helper'

def symbolize(klass)
  klass.to_s.underscore.to_sym
end

describe ContentBase do
  pending "Need to test the methods that are unique to the ContentBase class here"
end

ContentBase.content_classes.each do |c|
  describe c do
    describe "associations" do
      it { should have_many :assets }
      it { should have_many :bylines }
      it { should have_many :brels }
      it { should have_many :frels }
      it { should have_many :related_links }
      it { should have_many :queries }
      it { should have_many :audio }
      it { should have_one :content_category }
      it { should have_one(:category).through(:content_category) }
    end
    
    it "inherits from ContentBase" do
      object = build symbolize(c)
      object.should be_a ContentBase
    end
    
    describe "sorted_relations" do
      it "takes a list of frels and brels and returns an array of related records" do
        object = create symbolize(c), frel_count: 2, brel_count: 2
        sorted_relations = object.sorted_relations(object.frels.normal, object.brels.normal)
        sorted_relations.include?(object.frels.first.content).should be_true
        sorted_relations.include?(object.brels.first.related).should be_true
      end
      
      it "returns a blank array if there are no related objects" do
        object = create symbolize(c)
        object.sorted_relations(object.frels.normal, object.brels.notiein).should eq []
      end
    end
    
    describe "#published" do
      it "returns an ActiveRecord::Relation" do
        create symbolize(c)
        c.published.class.should eq ActiveRecord::Relation
      end
      
      it "only selects published content" do
        published = create_list symbolize(c), 3, status: 5
        unpublished = create_list symbolize(c), 2, status: 3
        c.published.count.should eq 3
      end

      it "can limit by published content" do
        published = create_list symbolize(c), 3, status: 5
        unpublished = create_list symbolize(c), 2, status: 4
        c.published.count.should eq 3
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
          object.link_path(anchor: "comments").should_not match "#comments"
        else  
          object.link_path(anchor: "comments").should match "#comments"
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
          object.remote_link_path.should_not match "http://www.scpr.org"
        else
          object.remote_link_path.should match "http://www.scpr.org"
        end
      end
    end
  end
end
