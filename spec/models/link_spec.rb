require "spec_helper"

describe Link do
  describe "associations" do
    it { should belong_to(:content) }
  end
  
  #-----------
  
  describe "scopes" do
    it "does not return null associations" do
      content = create :news_story
      link    = create :link, content: content
      Link.count.should eq 1
      link.update_column(:content_type, nil)
      Link.count.should eq 0
      content.related_links.should be_blank
    end
  end

  #-----------
  
  describe "domain" do
    it "returns nil if link is blank" do
      link = build :link, link: nil
      link.domain.should eq nil
    end
    
    it "returns the link's host" do
      link = build :link, link: "http://scpr.org/news"
      link.domain.should eq "scpr.org"
    end
  end
end
