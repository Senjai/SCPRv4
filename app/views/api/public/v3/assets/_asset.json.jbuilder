json.cache! [Api::Public::V3::VERSION, "v2", asset] do
  json.title    asset.title
  json.caption  asset.caption.present? ? asset.caption : asset.asset.caption
  json.owner    asset.owner

  if asset.native.present?
    json.native do
      json.type asset.native["class"]
      json.id   asset.native["videoid"]
    end
  end

  json.thumbnail do
    json.url    asset.lsquare.url
    json.width  asset.lsquare.width
    json.height asset.lsquare.height
  end

  json.small do
    json.url    asset.small.url
    json.width  asset.small.width
    json.height asset.small.height
  end

  json.large do
    json.url    asset.eight.url
    json.width  asset.eight.width
    json.height asset.eight.height
  end

  json.full do
    json.url    asset.full.url
    json.width  asset.full.width
    json.height asset.full.height
  end
end
