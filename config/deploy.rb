require "bundler/capistrano"
require 'thinking_sphinx/deploy/capistrano'

set :stages, %w{ production staging }
set :default_stage, "production"
require 'capistrano/ext/multistage'

# --------------
# Variables for all stages

set :application, "scprv4"
set :scm, :git
set :repository,  "git@github.com:SCPR/SCPRv4.git"
set :scm_verbose, true
set :deploy_via, :remote_cache
set :deploy_to, "/web/scprv4"

set :user, "scprv4"
set :use_sudo, false

# --------------
# Tasks for all stages

namespace :deploy do
  # --------------
  # Restart app
  task :start, :roles => [:app, :workers] do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => [:app, :workers] do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => [:app, :workers] do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  # --------------  
  # Skip asset precompile if no assets were changed
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision) rescue nil
      
      # Previous revision is blank or git log doesn't have any new lines mentioning assets
      if from.nil? || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
      else
        logger.info "No changes in assets - Skipping asset pre-compilation"
      end
    end
  end
end

# --------------
# Sphinx
namespace :remote_ts do
  task :start, :roles => :sphinx do
    thinking_sphinx.configure
    thinking_sphinx.start
  end
  
  task :stop, :roles => :sphinx do
    thinking_sphinx.stop
  end
  
  task :index, :roles => :sphinx do 
    thinking_sphinx.index
  end
end
