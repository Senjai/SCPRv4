json.id content.obj_key
json.title content.to_title
json.short_title content.short_headline
json.published_at content.published_at
json.teaser content.teaser.html_safe
json.body content.body.html_safe
json.permalink content.remote_link_path

if content.asset.present?
  json.thumbnail content.asset.lsquare.tag
end

json.byline content.byline
json.edit_path content.admin_edit_path
