json.cache! [Api::Public::V2::VERSION, "v1", program] do
  json.title          program.title
  json.slug           program.slug

  json.host         program.host
  json.airtime      program.airtime
  json.description  program.description.to_s.html_safe

  json.podcast_url(program.podcast_url) if program.podcast_url.present?
  json.rss_url(program.rss_url) if program.rss_url.present?
  json.public_url  program.public_url
end
