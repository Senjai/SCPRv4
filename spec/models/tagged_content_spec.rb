require "spec_helper"

describe TaggedContent do
  describe "associations" do
    it { should belong_to(:tag) }
    it { should belong_to(:content) }
  end  
end
