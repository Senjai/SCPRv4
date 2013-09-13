Scprv4::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.cache_store = :redis_content_store, "redis://10.226.4.234:6379/6"
#  config.cache_store = :redis_content_store, "redis://localhost:6379/5"

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"
  
  # Enable Postmark for transactional mail sending
  config.action_mailer.delivery_method          = :simple_postmark
  config.action_mailer.raise_delivery_errors    = true
  
  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true
  
  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  default_url_options[:host] = "www.scpr.org"

  config.scpr.host         = "www.scpr.org"
  config.scpr.media_root   = "/home/kpcc/media"
  config.scpr.media_url    = "http://media.scpr.org"
  config.scpr.resque_queue = :scprv4

  config.audio_vision.host      = "http://audiovision.scpr.org"
  config.audio_vision.api_path  = "/api/v1"

  config.node.server = "http://node.scprdev.org"
end
