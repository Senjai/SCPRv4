json.cache! content do
  json.id content.obj_key
  json.title content.to_title
  json.short_title content.short_headline
  json.byline content.byline
  json.published_at content.published_at
  json.teaser content.teaser.html_safe
  json.body content.body.html_safe
  json.permalink content.remote_link_path

  asset = content.assets.first
  json.thumbnail asset ? content.asset.lsquare.tag : nil


  if content.respond_to?(:category) && content.category.present?
    json.category do
      json.id content.category.id
      json.title content.category.title
      json.url content.category.remote_link_path
    end
  end


  json.assets content.assets do |asset|
    json.title asset.title
    json.caption asset.caption.present? ? asset.caption : asset.asset.caption
    json.owner asset.owner

    json.thumbnail do
      json.url asset.lsquare.url
      json.width asset.lsquare.width
      json.height asset.lsquare.height
    end

    json.small do
      json.url asset.small.url
      json.width asset.small.width
      json.height asset.small.height
    end

    json.large do
      json.url asset.eight.url
      json.width asset.eight.width
      json.height asset.eight.height
    end

    json.full do
      json.url asset.full.url
      json.width asset.full.width
      json.height asset.full.height
    end
  end



  if content.respond_to?(:bylines) && content.bylines.present?
    json.attributions content.bylines do |byline|
      json.name byline.display_name
      json.role_text byline.role_text
      json.role byline.role
    end
  end
end
