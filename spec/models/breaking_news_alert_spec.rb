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
  
  describe "published" do
    it "only returns published alerts" do
      pub = create :breaking_news_alert, is_published: true
      unpub = create :breaking_news_alert, is_published: false
      BreakingNewsAlert.published.should eq [pub]
    end
    
    it "orders by created_at desc" do
      BreakingNewsAlert.published.to_sql.should match /order by created_at desc/i
    end
  end
  
  describe "visible" do
    it "only returns visible alerts" do
      visible = create :breaking_news_alert, visible: true
      invisible = create :breaking_news_alert, visible: false
      BreakingNewsAlert.visible.should eq [visible]
    end
  end
  
  describe "latest_alert" do
    it "returns the first alert if it is published and visible" do
      alert = create :breaking_news_alert, is_published: true, visible: true
      BreakingNewsAlert.latest_alert.should eq alert
    end
    
    it "returns nil if the first alert is not published" do
      older = create :breaking_news_alert, created_at: Chronic.parse("yesterday"), is_published: true # Older alert, published
      latest = create :breaking_news_alert, created_at: Chronic.parse("now"), is_published: false # Latest alert, not published
      BreakingNewsAlert.latest_alert.should be_nil # Only looking at the latest alert
    end
    
    it "returns nil if there are no alerts" do
      BreakingNewsAlert.count.should eq 0
      BreakingNewsAlert.latest_alert.should be_nil
    end
    
    it "returns nil if the first alert is not visible" do
      older = create :breaking_news_alert, created_at: Chronic.parse("yesterday"), visible: true # Older alert, visible
      latest = create :breaking_news_alert, created_at: Chronic.parse("now"), visible: false # Latest alert, invisible
      BreakingNewsAlert.latest_alert.should be_nil # Only looking at the latest alert
    end
    
    it "orders by the created_at date" do
      create_list :breaking_news_alert, 3
      BreakingNewsAlert.latest_alert.should eq BreakingNewsAlert.order("created_at desc").first
    end
  end
end