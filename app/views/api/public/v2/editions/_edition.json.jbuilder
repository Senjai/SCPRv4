json.cache! [Api::Public::V2::VERSION, "v1", edition] do
  json.id           edition.id
  json.published_at edition.published_at

  json.abstracts edition.abstracts.each do |abstract|
    json.source                 abstract.source
    json.url                    abstract.url
    json.headline               abstract.headline
    json.summary                abstract.summary
    json.article_published_at   abstract.article_published_at

    json.assets do |asset|
      json.partial! "api/public/v2/assets/collection", assets: abstract.assets
    end

    json.audio do
      json.partial! "api/public/v2/audio/collection", audio: abstract.audio
    end

    if abstract.category.present?
      json.category do
        json.partial! "api/public/v2/categories/category", category: abstract.category
      end
    end
  end
end
