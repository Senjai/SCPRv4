require "spec_helper"

describe Concern::Associations::RelatedContentAssociation do
  describe "associations" do
    subject { TestClass::Story.new }
  
    it { should have_many(:brels).class_name("Related").dependent(:destroy) }
    it { should have_many(:frels).class_name("Related").dependent(:destroy) }
  end
  
  #-------------------------
  # TODO: Rewrite this spec, and the method
  describe "#sorted_relations" do
    it "takes a list of frels and brels and returns an array of related records" do
      object = create :news_story, frel_count: 2, brel_count: 2
      sorted_relations = object.sorted_relations(object.frels, object.brels)
      sorted_relations.should include object.frels.first.content
      sorted_relations.should include object.brels.first.related
    end
    
    it "returns a blank array if there are no related objects" do
      object = create :news_story
      object.sorted_relations(object.frels, object.brels).should eq []
    end
  end
end
