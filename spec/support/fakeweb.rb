FakeWeb.allow_net_connect = false

if !defined?(AH_JSON)
  AH_JSON = {
    :asset   => File.read("#{Rails.root}/spec/fixtures/api/assethost/asset.json"),
    :outputs => File.read("#{Rails.root}/spec/fixtures/api/assethost/outputs.json")
  }
end

module FakeWeb
  def self.load_callback
    FakeWeb.register_uri(:any, %r|a\.scpr\.org\/api\/outputs|, body: AH_JSON[:outputs], content_type: "application/json")
    FakeWeb.register_uri(:any, %r|a\.scpr\.org\/api\/assets|, body: AH_JSON[:asset], content_type: "application/json")
    FakeWeb.register_uri(:any, %r|a\.scpr\.org\/api\/as_asset|, body: AH_JSON[:asset], content_type: "application/json")
  end
end
