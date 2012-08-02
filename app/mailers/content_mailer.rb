class ContentMailer < ActionMailer::Base
  
  def email_content()
    
    mail(
      :subject => 'hello',
      :to      => 'sdillingham@scpr.org',
      :from    => 'scprweb@scpr.org',
      :tag     => 'content-share'
    ) do
      response = YourMailer.email.deliver!.parsed_response
      
      response['MessageID']
        # => "b7bc2f4a-e38e-4336-af7d-e6c392c2f817"
      response['ErrorCode']
        # => 0
        
    end
  end
  
end
