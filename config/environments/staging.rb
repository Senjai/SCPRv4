Scprv4::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = true


  # There's nothing expiring the cache on staging so don't use it
  # If you change this to true, manually expire the cache
  # by SSHing to the server and running `Rails.cache.clear`
  # from the Rails console.

  # You can also switch this to true, change the Redis path to point to cache1,
  # and change staging in database.yml to use mercer_new (production).
  # That would be good for figuring out a problem that was only occurring
  # in production.

  config.action_controller.perform_caching = false
  config.cache_store = :redis_content_store, "redis://localhost:6379/6"


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

  config.dbsync.filename    = "mercer.dump"
  config.dbsync.local_dir   = "/web/scprv4/dbsync" # No trailing slash
  config.dbsync.remote_host = "scprdb@66.226.4.229"
  config.dbsync.remote_dir  = "~scprdb"

  default_url_options[:host] = "scpr.org"

  config.scpr.host         = "staging.scprdev.org"
  config.scpr.media_root   = "/home/kpcc/media"
  config.scpr.media_url    = "http://media.scpr.org"
  config.scpr.resque_queue = :scprv4

  config.node.server = "http://node.scprdev.org"
end
