class ContentMailer < ActionMailer::Base
  def email_content(message)
    @message = message
    @content = message.content
    mail  to:       message.to_email, 
          from:     "scprweb@scpr.org", 
          subject:  "#{message.from} " \
                    "has shared an article with you from 89.3 KPCC",
          reply_to: message.from_email
  end  
end
