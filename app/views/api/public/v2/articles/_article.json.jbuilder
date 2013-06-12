json.cache! [Api::Public::V2::VERSION, "v1", article.original_object] do
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
      json.partial! "api/public/v2/categories/category", category: article.category
    end
  end


  json.assets article.assets do |asset|
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


  json.audio do
    json.partial! "api/public/v2/audio/collection", audio: article.audio
  end


  json.attributions article.attributions do |byline|
    json.name       byline.display_name
    json.role_text  byline.role_text
    json.role       byline.role
  end

  json.permalink    article.public_url # Deprecated
end
