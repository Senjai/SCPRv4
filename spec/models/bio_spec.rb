require "spec_helper"

describe Bio do
  it { should belong_to(:user) }
  
  describe "twitter_url" do
    it "returns a twitter URL if twitter handle is present" do
      bio = build :bio, twitter: "@larrymantle"
      bio.twitter_url.should match /twitter\.com/
    end
    
    it "subs out the @" do
      bio = build :bio, twitter: "@larrymantle"
      bio.twitter_url.should_not match /@/
    end
    
    it "returns nil if twitter handle is not present" do
      bio = build :bio, twitter: ""
      bio.twitter_url.should be_nil
    end
  end
end