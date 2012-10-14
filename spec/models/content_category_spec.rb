require "spec_helper"

describe ContentCategory do
  describe "associations" do
    it { should belong_to(:content) }
    it { should belong_to(:category) }
  end
end
