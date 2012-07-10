require "spec_helper"

describe Tag do
  describe "associations" do
    it { should have_many(:tagged).class_name("TaggedContent") }
    it { should have_many(:content).through(:tagged) }
  end
end
