class ContentMailer < ActionMailer::Base
  
  def email_content(message)
    
    mail :to => "sdillingham@scpr.org", :from => "scprweb@scpr.org", :subject => "Test Email Share", :body => "This is a sample shared article"
    
  end
  
end
