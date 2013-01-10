# --------------
# Variables
set :branch, "master"
set :rails_env, "staging"

# --------------
# Roles
scprdev = "66.226.4.241"
role :app,      scprdev
role :web,      scprdev
role :workers,  scprdev
role :db,       scprdev, :primary => true
role :sphinx,   scprdev


# --------------
# Callbacks
after "deploy:update_code", "dbsync:pull"
after "deploy:update_code", "thinking_sphinx:staging:index"


# --------------
# Tasks
namespace :deploy do
  task :restart, roles: [:app] do
    run "touch #{current_release}/tmp/restart.txt"
  end
end


namespace :dbsync do
  task :pull do
    if [true, 1].include? syncdb
      run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} dbsync:pull"
    else
      logger.info "SKIPPING dbsync (syncdb set to #{syncdb})"
    end
  end
end

namespace :thinking_sphinx do
  namespace :staging do
    task :index do
      if [true, 1].include? ts_index
        thinking_sphinx.index
      else
        logger.info "SKIPPING thinking_sphinx:index (ts_index set to #{ts_index})"
      end
    end
  end
end
