require "spec_helper"

describe Tag do
  describe "associations" do
    it { should have_many(:tagged).class_name("TaggedContent") }
  end
end
