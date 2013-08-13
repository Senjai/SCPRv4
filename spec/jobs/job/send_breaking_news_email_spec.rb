require 'spec_helper'

describe Job::SendBreakingNewsEmail do
  before :each do
    stub_request(:post, %r|assets/email|).to_return({
      :content_type   => "application/json",
      :body           => load_fixture("api/eloqua/email.json")
    })

    stub_request(:post, %r|assets/campaign/active|).to_return({
      :content_type   => "application/json",
      :body           => load_fixture("api/eloqua/campaign_activated.json")
    })

    stub_request(:post, %r|assets/campaign\z|).to_return({
      :content_type   => "application/json",
      :body           => load_fixture("api/eloqua/email.json")
    })
  end

  describe '::perform' do
    it 'sends the email' do
      alert = create :breaking_news_alert, :email, :published
      alert.email_sent?.should eq false

      Job::SendBreakingNewsEmail.perform(alert.id)
      alert.reload.email_sent?.should eq true
    end
  end
end
