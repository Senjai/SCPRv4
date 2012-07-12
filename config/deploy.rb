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

set :user, "scprv4"
set :use_sudo, false

# Pass these in with -s to override: 
#    cap deploy -s force_assets=true -s force_npm=true
set :force_assets, false
set :force_npm, false

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
  # Install & Rebuild packages if package.json was updated
  # This installs everything into #{latest_release}/node_modules,
  # moves it to #{shared_path}/node_modules, and then symlinks
  # #{shared_path}/node_modules into #{latest_release}
  # This allows the application to share packages between
  # deploys if possible.
  task :npm, roles: :web do
    from = source.next_revision(current_revision) rescue nil
    if force_npm || from.nil? || capture("cd #{latest_release} && #{source.local.log(from)} package.json | wc -l").to_i > 0
      run "cd #{latest_release} && npm install && npm rebuild"
      run "mv -f #{lateset_release}/node_modules/ #{shared_path}"
    else
      logger.info "package.json not updated. SKIPPING npm install"
    end
    
    run "ln -nsf #{shared_path}/node_modules/ #{latest_release}"
  end
  
  # --------------
  # Skip asset precompile if no assets were changed
  namespace :assets do
    task :precompile, roles: :web do
      from = source.next_revision(current_revision) rescue nil
      
      # Previous revision is blank or git log doesn't 
      # have any new lines mentioning assets
      if force_assets || from.nil? || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
      else
        logger.info "No changes in assets - SKIPPING asset pre-compilation"
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
