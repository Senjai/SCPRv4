require 'spec_helper'

def symbolize(klass)
  klass.to_s.underscore.to_sym
end

describe ContentBase do # Using news_story here arbitrarily
  describe "sorted_relations" do
    it "takes a list of frels and brels and returns an array of related records" do
      object = create :news_story, frel_count: 2, brel_count: 2
      sorted_relations = object.sorted_relations(object.frels.normal, object.brels.normal)
      sorted_relations.should include object.frels.first.content
      sorted_relations.should include object.brels.first.related
    end
    
    it "returns a blank array if there are no related objects" do
      object = create :news_story
      object.sorted_relations(object.frels.normal, object.brels.notiein).should eq []
    end
  end
end

ContentBase.content_classes.each do |c|
  describe c do
    it "inherits from ContentBase" do
      object = build symbolize(c)
      object.should be_a ContentBase
    end
    
    it { should respond_to :headline }
    it { should respond_to :short_headline }
    it { should respond_to :body }
    it { should respond_to :teaser }
    it { should respond_to :link_path }
    it { should respond_to :remote_link_path }
    it { should respond_to :obj_key }
    it { should respond_to :auto_published_at }
    it { should respond_to :has_format? }
    it { should respond_to :byline_elements }
    
    it "must return byline_elements as an array" do
      object = build symbolize(c)
      object.byline_elements.should be_a Array
    end
    
    #-----------------
    
    describe "associations" do
      it { should have_many(:assets).class_name("ContentAsset").dependent(:destroy) }
      it { should have_many(:bylines).class_name("ContentByline").dependent(:destroy) }
      it { should have_many :brels }
      it { should have_many :frels }
      it { should have_many :related_links }
      it { should have_many :queries }
      it { should have_many :audio }
      it { should have_one :content_category }
      it { should have_one(:category).through(:content_category) }
    end
    
    #-----------------
    
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
    end
    
    #-----------------
    
    describe "#link_path" do      
      it "accepts an options hash" do
        object = create symbolize(c)
        lambda { object.link_path(anchor: "comments") }.should_not raise_error
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
    
    #-----------------
    
  end
end
