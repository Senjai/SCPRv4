## NPR gem configuration
NPR.configure do |config|
  config.apiKey = Rails.application.config.api["npr"]["api_key"]
end
