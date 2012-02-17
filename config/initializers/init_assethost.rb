# AssetHost = YAML.load_file("#{Rails.root}/config/assethost.yml")[Rails.env]

module AssetHost
  def self.[](key)
    unless @config
      raw_config = File.read("#{Rails.root}/config/assethost.yml")
      @config = YAML.load(raw_config)[Rails.env].symbolize_keys
    end
    @config[key.to_sym]
  end

  def self.[]=(key, value)
    @config[key.to_sym] = value
  end
end
