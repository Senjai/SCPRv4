json.cache! [Api::Public::V3::VERSION, "v1", episode] do
  json.title          episode.headline
  json.teaser         episode.body.html_safe

  json.air_date     episode.air_date
  json.public_url   episode.public_url

  json.assets do |asset|
    json.partial! api_view_path("assets", "collection"), assets: episode.assets
  end

  json.audio do
    json.partial! api_view_path("audio", "collection"), audio: episode.audio.available
  end

  json.program do
    json.partial! api_view_path("programs", "program"), program: episode.show
  end

  json.segments do
    json.partial! 'api/public/v3/articles/collection', articles: episode.segments.published.map(&:to_article)
  end
end
