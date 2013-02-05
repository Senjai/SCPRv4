API_KEYS = YAML.load_file("#{Rails.root}/config/api_keys.yml")[Rails.env]
DFP_ADS = YAML.load_file("#{Rails.root}/config/dfp_ads.yml")
