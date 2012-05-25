require "spec_helper"

describe Link do
  it { should belong_to(:content) }
  it "does not return ShowSeries" do
    pending "mysql views..."
    #content = create :news_story
    #link = create :link, content: content
    #link.update_attributes(content_type: "ShowSeries")
    #Link.count should eq 0
    #content.links.should be_blank
  end
  
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
  