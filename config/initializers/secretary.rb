# Configuration for Secretary
require_dependency "secretary"

Secretary::Config.configure do |config|
  config.user_class = "::AdminUser"
end

# Setup Secretary to be Outposty
module Secretary
  class Version
    outpost_model
  end
end
