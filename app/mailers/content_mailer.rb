class ContentMailer < ActionMailer::Base
  
  def email_content(message)
    @message = message
    mail( 
      :to => message.email, 
      :from => "scprweb@scpr.org", 
      :subject => "#{message.name} has shared an article with you from 89.3 KPCC", 
      :template_path => 'content_email/email',
      :template_name => 'template')
  end
  
end
