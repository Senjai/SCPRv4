API_CONFIG = YAML.load_file("#{Rails.root}/config/api_config.yml")[Rails.env]
APP_CONFIG = YAML.load_file("#{Rails.root}/config/app_config.yml")
DFP_ADS = YAML.load_file("#{Rails.root}/config/dfp_ads.yml")
