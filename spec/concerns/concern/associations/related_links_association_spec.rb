require "spec_helper"

describe Concern::Associations::RelatedLinksAssociation do
  describe "associations" do
    subject { TestClass::Story.new }
    
    it { should have_many(:related_links).dependent(:destroy) }
  end
end
