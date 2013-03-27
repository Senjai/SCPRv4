require "spec_helper"

describe RelatedLink do
  describe "associations" do
    it { should belong_to(:content) }
  end

  #-----------
  
  describe "domain" do
    it "returns nil if link is blank" do
      link = build :related_link, url: nil
      link.domain.should eq nil
    end
    
    it "returns the link's host" do
      link = build :related_link, url: "http://scpr.org/news"
      link.domain.should eq "scpr.org"
    end
  end
end
