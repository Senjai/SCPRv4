json.cache! [Api::Public::V3::VERSION, "v2", edition] do
  json.id           edition.id
  json.published_at edition.published_at

  json.abstracts edition.abstracts.each do |abstract|
    json.source                 abstract.source
    json.url                    abstract.url
    json.headline               abstract.headline
    json.summary                abstract.summary
    json.article_published_at   abstract.article_published_at
    
    json.assets do |asset|
      json.partial! api_view_path("assets", "collection"), assets: abstract.assets
    end

    json.audio do
      json.partial! api_view_path("audio", "collection"), audio: abstract.audio
    end

    if abstract.category.present?
      json.category do
        json.partial! api_view_path("categories", "category"), category: abstract.category
      end
    end
  end
end
