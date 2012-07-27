class ContentMailer < ActionMailer::Base
  
  def email_content()
    
    mail(
      :subject => 'hello',
      :to      => 'sdillingham@scpr.org',
      :from    => 'scprweb@scpr.org',
      :tag     => 'content-share'
    )
  end
  
end
