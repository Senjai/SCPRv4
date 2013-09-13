##
# This is just a template, so we can keep `development.rb`
# out of version control. It contains the configuration
# necessary for SCPRv4 to run properly in development,
# and sets some sensible defaults.
#
# COPY this file to `config/environments/development.rb`
# and modify as needed.
# The repository's `.gitignore` is already set to ignore
# `config/environments/development.rb`.
#
# The following paths will need to be modified for your machine:
#   * config.scpr.media_root
#   * config.scpr.media_url
#
# You'll also need to create a `dbsync` directory at the same
# directory level as the SCPRv4 application directory, or otherwise
# modify the `config.dbsync.local_dir` configuration.
#
Scprv4::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true

  config.action_controller.perform_caching = false
  config.cache_store = :redis_content_store, "redis://localhost:6379/5"

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Serve files from public/
  config.serve_static_assets = true

  # Gmail
  config.action_mailer.delivery_method       = :smtp
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings         = {
    :address              => 'smtp.gmail.com',
    :port                 => 587,
    :domain               => 'kpcc.org',
    :user_name            => 'kpccdev@gmail.com',
    :password             => '',
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }

  config.dbsync.filename    = "mercer.dump"
  config.dbsync.local_dir   = "#{Rails.root}/../dbsync" # No trailing slash
  config.dbsync.remote_host = "66.226.4.229"
  config.dbsync.remote_dir  = "~scprdb"

  default_url_options[:host] = "localhost:3000"

  config.scpr.host         = "localhost:3000"
  config.scpr.media_root   = "/Users/bryan/projects/media"
  config.scpr.media_url    = "file:///Users/bryan/projects/media"
  config.scpr.resque_queue = :scprv4

  config.audio_vision.host      = "http://audiovision.scpr.org"
  config.audio_vision.api_path  = "/api/v1"

  config.node.server = "http://localhost:8888"
end
