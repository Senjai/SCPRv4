class ContentMailer < ActionMailer::Base
  def email_content(message)
    @message = message
    @content = message.content
    mail  :to       => message.email, 
          :from     => "scprweb@scpr.org", 
          :subject  => "#{message.name} has shared an article with you from 89.3 KPCC"
  end  
end
