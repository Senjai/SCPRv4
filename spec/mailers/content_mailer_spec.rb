require "spec_helper"

describe ContentMailer do
  describe "email_content" do
    let(:content) { create :news_story }
    let(:message) { build :content_email, 
                    content:    content, 
                    from_name:  "Bryan Ricker!", 
                    from_email: "bricker@scpr.org", 
                    to_email:   "bricker@kpcc.org",
                    body:       "Some cool article" 
                  }
    let(:mail)    { ContentMailer.email_content(message) }
    
    it "sends to the e-mail passed in" do
      mail.to.should eq [message.to_email]
    end
    
    it "sets reply-to header to the from_email" do
      mail.reply_to.should eq [message.from_email]
    end
    
    it "puts the from text in the subject" do
      mail.subject.should match message.from
    end
    
    it "renders the email template" do
      mail.body.encoded.should_not be_blank
    end
    
    it "uses the content in the body" do
      mail.body.encoded.should match content.headline
      mail.body.encoded.should match content.teaser
    end
    
    it "uses the from text in the body" do
      mail.body.encoded.should match message.from
    end
    
    it "shows the message body if present" do
      mail.body.encoded.should match message.body
    end
  end
end
