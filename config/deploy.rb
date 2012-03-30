require "bundler/capistrano"
require 'thinking_sphinx/deploy/capistrano'
require 'new_relic/recipes'

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

task :staging do
  roles.clear
  set :rails_env, :scprdev
  set :branch, "master"
  role :app, "scprdev.org"
  role :web, "scprdev.org"
  role :db,  "scprdev.org", :primary => true
  role :sphinx, "scprdev.org"  
end

namespace :deploy do
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
end

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
after "deploy:update", "newrelic:notice_deployment"
