DFP_ADS = YAML.load_file("#{Rails.root}/config/dfp_ads.yml")

RSS_SPEC           = { 'version' => '2.0', 'xmlns:dc' => "http://purl.org/dc/elements/1.1/", 'xmlns:atom' => "http://www.w3.org/2005/Atom" }
SPHINX_MAX_MATCHES = 1000
STATIC_TABLES      = %w{ permissions }

CONNECT_DEFAULTS = {
  :facebook      => "http://www.facebook.com/kpccfm",
  :twitter       => "kpcc",
  :rss           => "http://wwww.scpr.org/feeds/all_news",
  :podcast       => "http://www.scpr.org/podcasts/news",
  :web           => "http://scpr.org"
}
