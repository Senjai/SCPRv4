require "bundler/capistrano"
require 'thinking_sphinx/deploy/capistrano'

set :application, "scprv4"
set :scm, :git
set :repository,  "git@github.com:SCPR/SCPRv4.git"
set :branch, "master"
set :scm_verbose, true
set :deploy_via, :remote_cache

set :deploy_to, "/web/scprv4"
set :rails_env, :production
set :user, "scprv4"

role :app, "scprdev.org"
role :web, "scprdev.org", :asset_host_syncher => true
role :db,  "scprdev.org", :primary => true

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

namespace :bdv4 do  
  desc "Link tmp/cache from shared"
  task :link_cache, :roles => :web do
    run "ln -s #{deploy_to}/shared/cache #{deploy_to}/current/tmp/cache"
  end
end

task :before_update_code, :roles => [:app] do
  thinking_sphinx.stop
end

task :after_update_code, :roles => [:app] do
  #symlink_sphinx_indexes
  thinking_sphinx.configure
  thinking_sphinx.start
end

after "deploy:symlink", "bdv4:link_cache"
