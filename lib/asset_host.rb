##
# AssetHost
#
# API interaction with AssetHost
#
module AssetHost
  ah       = Rails.application.config.assethost
  api_root = ah.server
  
  API_ROOT = "http://#{api_root}"
end
