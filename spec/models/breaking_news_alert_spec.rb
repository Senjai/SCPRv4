require "spec_helper"

describe BreakingNewsAlert do
  describe "get_alert" do
    it "returns the first alert if it is published" do
      create :breaking_news_alert, is_published: true
      BreakingNewsAlert.get_alert.should be_present
    end
    
    it "returns nil if the first alert is not published" do
      create :breaking_news_alert, created_at: Chronic.parse("yesterday"), is_published: true # Older alert, published
      create :breaking_news_alert, created_at: Chronic.parse("now"), is_published: false # Latest alert, not published
      BreakingNewsAlert.get_alert.should be_nil # Only looking at the latest alert
    end
    
    it "returns nil if there are no alerts" do
      BreakingNewsAlert.count.should eq 0
      BreakingNewsAlert.get_alert.should be_nil
    end
  end
end