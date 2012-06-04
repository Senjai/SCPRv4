require "spec_helper"

describe BreakingNewsAlert do
  describe "email_subject" do
    it "contains break-type" do
      alert = build :breaking_news_alert
      alert.email_subject.should match alert.break_type
    end
    
    it "contains headline" do
      alert = build :breaking_news_alert
      alert.email_subject.should match alert.headline
    end
  end
  
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
    
    it "orders by the created_at date" do
      create_list :breaking_news_alert, 3
      BreakingNewsAlert.get_alert.should eq BreakingNewsAlert.order("created_at desc").first
    end
  end
end