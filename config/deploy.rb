# --------------
# Requires and Multistage setup

require "bundler/capistrano"
require 'thinking_sphinx/deploy/capistrano'

set :stages, %w{ production staging }
set :default_stage, "production"
require 'capistrano/ext/multistage'


# --------------
# Universal Variables

set :application, "scprv4"
set :scm, :git
set :repository,  "git@github.com:SCPR/SCPRv4.git"
set :scm_verbose, true
set :deploy_via, :remote_cache
set :deploy_to, "/web/scprv4"
set :keep_releases, 5

set :user, "scprv4"
set :use_sudo, false
set :group_writable, false

set :maintenance_template_path, "public/maintenance.erb"
set :maintenance_basename, "maintenance"

# Pass these in with -s to override: 
#    cap deploy -s force_assets=true
set :force_assets,  false # If assets wouldn't normally be precompiled, force them to be
set :skip_assets,   false # If assets are going to be precompiled, force them NOT to be
set :ts_index,      false # Staging only - Whether or not to run the sphinx index on drop
set :syncdb,        false # Staging only - Whether or not to run a dbsync to mercer_staging
set :restart_delay, 40

# --------------
# Universal Callbacks
after "deploy:update", "deploy:cleanup"


# --------------
# Universal Tasks
namespace :deploy do
  # --------------
  # Override disable/enable
  # https://github.com/capistrano/capistrano/blob/master/lib/capistrano/recipes/deploy.rb
  namespace :web do
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm -f #{shared_path}/system/#{maintenance_basename}.html" }

      reason    = ENV['REASON']
      deadline  = ENV['UNTIL']

      template = File.read(maintenance_template_path)
      result   = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/#{maintenance_basename}.html", :mode => 0644      
    end

    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm -f #{shared_path}/system/#{maintenance_basename}.html"
    end
  end
  
  # --------------
  # Skip asset precompile if no assets were changed
  namespace :assets do
    task :precompile, roles: :web do
      from = source.next_revision(current_revision) rescue nil
      
      # Previous revision is blank or git log doesn't 
      # have any new lines mentioning assets
      if [true, 1].include?(force_assets) || from.nil? || 
          capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
          if ![true, 1].include? skip_assets
            run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
          else
            logger.info "SKIPPING asset pre-compilation (skip_assets true)"
          end
      else
        logger.info "No changes in assets. SKIPPING asset pre-compilation"
      end
    end
  end
end

# --------------
# Sphinx
namespace :remote_ts do
  task :start, roles: :sphinx do
    thinking_sphinx.configure
    thinking_sphinx.start
  end
  
  task :stop, roles: :sphinx do
    thinking_sphinx.stop
  end
  
  task :index, roles: :sphinx do 
    thinking_sphinx.index
  end
end
