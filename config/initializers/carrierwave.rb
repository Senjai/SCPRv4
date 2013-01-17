CarrierWave.configure do |config|
  config.permissions = 0777
  config.directory_permissions = 0777
  config.storage = :file
end
