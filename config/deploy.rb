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
set :use_sudo, false

role :app, "scprdev.org"
role :web, "scprdev.org", :asset_host_syncher => true
role :db,  "scprdev.org", :primary => true
role :sphinx, "media.scpr.org"

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
end

#task :before_update_code, :roles => [:app] do
#  thinking_sphinx.stop
#end

#task :after_update_code, :roles => [:app] do
  #symlink_sphinx_indexes
#  thinking_sphinx.configure
#  thinking_sphinx.start
#end