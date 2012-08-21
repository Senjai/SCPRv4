require "spec_helper"

describe ContentMailer do
  describe "email_content" do
    let(:content) { create :news_story }
    let(:message) { build :content_email, content: content, name: "Bryan Ricker!", email: "bricker@scpr.org" }
    let(:mail)    { ContentMailer.email_content(message) }
    
    it "sends to the e-mail passed in" do
      mail.to.should eq [message.email]
    end
    
    it "puts the name in the subject" do
      mail.subject.should match message.name
    end
    
    it "renders the email template" do
      mail.body.encoded.should_not be_blank
    end
    
    it "uses the content in the body" do
      mail.body.encoded.should match content.headline
      mail.body.encoded.should match content.teaser
    end
    
    it "uses the message in the body" do
      mail.body.encoded.should match message.name
    end
    
    it "shows the message body if present" do
      message.body = "Hello, this is a personal message"
      mail.body.encoded.should match message.body
    end
  end
end
