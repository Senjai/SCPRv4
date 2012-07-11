require "bundler/capistrano"
require 'thinking_sphinx/deploy/capistrano'
require 'new_relic/recipes'
require 'san_juan'

set :application, "scprv4"
set :scm, :git
set :repository,  "git@github.com:SCPR/SCPRv4.git"
set :branch, "master"
set :scm_verbose, true
set :deploy_via, :remote_cache

set :deploy_to, "/web/scprv4"
set :rails_env, :production
set :user, "scprv4"
set :use_sudo, false

role :app, "web1.scpr.org", "web2.scpr.org"
role :web, "web1.scpr.org", "web2.scpr.org"
role :db,  "web2.scpr.org", :primary => true
role :sphinx, "media.scpr.org"
role :god, "media.scpr.org"

set :god_config_path "/etc/god/config"
san_juan.role :god, "scprv4-resque"

# --------------
# cap staging deploy
task :staging do
  roles.clear
  set :rails_env, :scprdev
  set :branch, "master"
  role :app, "scprdev.org"
  role :web, "scprdev.org"
  role :db,  "scprdev.org", :primary => true
  role :sphinx, "scprdev.org"
  
  after "deploy:update_code", "thinking_sphinx:index"
end


namespace :deploy do
  # --------------
  # Restart app
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
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


after "deploy:update_code", "thinking_sphinx:configure"
after "deploy:update_code", "god:app:scprv4-resque:restart"
after "deploy:update", "newrelic:notice_deployment"
