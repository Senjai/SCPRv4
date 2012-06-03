require 'spec_helper'

def symbolize(klass)
  klass.to_s.underscore.to_sym
end

describe ContentBase do # Using news_story here arbitrarily
  describe "#teaser" do
    it "returns teaser if defined" do
      teaser = "This is a short teaser"
      object = build :news_story, teaser: teaser
      object.teaser.should eq teaser
    end

    it "creates teaser from long paragraph if not defined" do
      long_body = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a enim a leo auctor lobortis. Etiam aliquam metus sit amet nulla blandit molestie. Cras lobortis odio non turpis laoreet non congue libero commodo. Vestibulum dolor nibh, eleifend eu suscipit eget, egestas sed diam. Proin cursus rutrum nibh eget consequat. Donec viverra augue sed nisl ultrices venenatis id eget quam. Cras id dui a magna tristique fermentum in sit amet lacus. Curabitur urna metus, mattis vel mollis quis, placerat vitae turpis.
          Phasellus et tortor eget mauris imperdiet fermentum. Mauris a rutrum augue. Quisque at fringilla libero. Phasellus vitae nisl turpis, at sodales erat. Duis et risus orci, at placerat quam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam sed nibh non odio pretium rhoncus et nec ipsum. Nam sed dignissim velit."
      object = build :news_story, body: long_body, teaser: nil
      object.teaser.should eq "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a enim a leo auctor lobortis. Etiam aliquam metus sit amet nulla blandit molestie. Cras lobortis odio non turpis laoreet..."
    end

    it "returns the full first paragraph if it's short enough" do
      short_first_paragraph = "This is just a short paragraph."
      object = build :news_story, body: "#{short_first_paragraph}\n And some more!", teaser: nil
      object.teaser.should eq short_first_paragraph
    end
  end
  
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
  
  describe "#short_headline" do
    it "returns short_headline if defined" do
      short_headline = "Short"
      object = build :news_story, _short_headline: short_headline
      object.short_headline.should eq short_headline
    end

    it "returns headline if not defined" do
      object = build :news_story, _short_headline: nil
      object.short_headline.should eq object.headline
    end
  end
  
  describe "#remote_link_path" do # ContentShell overrides this method
    it "points to scpr.org" do
      object = create :news_story
      object.remote_link_path.should match "http://www.scpr.org"
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
    it { should respond_to :byline_elements }
    it { should respond_to :remote_link_path }
    it { should respond_to :link_path }
    
    it "must return byline_elements as an array" do
      object = build symbolize(c)
      object.byline_elements.should be_a Array
    end
    
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
  end
end
