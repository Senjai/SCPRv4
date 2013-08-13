require 'spec_helper'

describe Job::SendBreakingNewsMobileNotification do
  before :each do
    stub_request(:post, %r|api\.parse\.com|).to_return(body: { result: true }.to_json)
  end

  describe '::perform' do
    it 'sends the mobile notification' do
      alert = create :breaking_news_alert, :mobile, :published
      alert.mobile_notification_sent?.should eq false

      Job::SendBreakingNewsMobileNotification.perform(alert.id)
      alert.reload.mobile_notification_sent?.should eq true
    end
  end
end
