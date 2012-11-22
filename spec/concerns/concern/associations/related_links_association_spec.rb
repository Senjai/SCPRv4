require "spec_helper"

describe Concern::Associations::RelatedLinksAssociation do
  describe "associations" do
    subject { TestClass::Story.new }
    
    it { should have_many(:related_links).class_name("Link").conditions("link_type != 'query'").dependent(:destroy) }
    it { should have_many(:queries).class_name("Link").conditions(link_type: "query").dependent(:destroy) }
  end
end
