json.cache! [Api::Public::V3::VERSION, "v2", program] do
  json.title          program.title
  json.slug           program.slug
  json.air_status     program.air_status
  json.twitter_handle(program.twitter_handle) if program.twitter_handle.present?

  json.host         program.host
  json.airtime      program.airtime
  json.description  program.description.to_s.html_safe

  json.podcast_url(program.podcast_url) if program.podcast_url.present?
  json.rss_url(program.rss_url) if program.rss_url.present?
  json.public_url  program.public_url
end
