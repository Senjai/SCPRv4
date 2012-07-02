require "spec_helper"

describe ContentByline do
  describe "associations" do
    it { should belong_to(:user).class_name("Bio") }
    it { should belong_to(:content) }
  end
  
  describe "scopes" do
    describe "primary" do
      it "only returns records where role is primary" do
        primary = create :byline, role: ContentByline::ROLE_PRIMARY
        secondary = create :byline, role: ContentByline::ROLE_SECONDARY
        contributing = create :byline, role: ContentByline::ROLE_CONTRIBUTING
        ContentByline.primary.should eq [primary]
      end
    end
  end 
end