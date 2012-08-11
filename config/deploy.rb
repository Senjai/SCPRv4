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
set :keep_releases, 25

set :user, "scprv4"
set :use_sudo, false
set :group_writable, false

set :maintenance_template_path, "public/maintenance.erb"

# Pass these in with -s to override: 
#    cap deploy -s force_assets=true
set :force_assets, false
set :ts_index, true # Staging only
set :dbsync, false # Staging only


# --------------
# Universal Callbacks
after "deploy:update", "deploy:cleanup"


# --------------
# Universal Tasks

namespace :deploy do
  # --------------
  # Restart app
  task :start, roles: [:app, :workers] do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, roles: [:app, :workers] do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, roles: [:app, :workers] do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  
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
      if force_assets || 
          from.nil? || 
          capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
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
