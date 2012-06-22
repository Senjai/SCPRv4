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
    it "only returns one result" do
      create_list :breaking_news_alert, 3
      BreakingNewsAlert.latest_alert.should be_a BreakingNewsAlert
    end
  end
end