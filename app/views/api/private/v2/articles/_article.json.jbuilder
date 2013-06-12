# Pass an Article object into here.
json.id               article.id
json.title            article.short_title # The aggregator wants short titles
json.public_datetime  article.public_datetime
json.teaser           article.teaser.html_safe
json.body             article.body.html_safe
json.public_url       article.public_url
json.edit_url         article.edit_url
json.byline           article.byline

if article.asset.present?
  json.thumbnail article.asset.lsquare.tag
end
