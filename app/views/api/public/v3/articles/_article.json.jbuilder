json.cache! [Api::Public::V3::VERSION, "v1", article.original_object] do
  json.id           article.id
  json.title        article.title
  json.short_title  article.short_title
  json.published_at article.public_datetime
  json.byline       article.byline
  json.teaser       article.teaser.html_safe
  json.body         article.body.html_safe
  json.public_url   article.public_url


  asset = article.assets.first
  json.thumbnail asset ? asset.lsquare.tag : nil


  if article.category.present?
    json.category do
      json.partial! api_view_path("categories", "category"),
        category: article.category
    end
  end

  json.assets do |asset|
    json.partial! api_view_path("assets", "collection"),
      assets: article.assets
  end

  json.audio do
    json.partial! api_view_path("audio", "collection"),
      audio: article.audio
  end

  json.attributions article.attributions do |byline|
    json.name       byline.display_name
    json.role_text  byline.role_text
    json.role       byline.role
  end
end
