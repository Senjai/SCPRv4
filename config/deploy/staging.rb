# --------------
# Variables
set :branch, "master"
set :rails_env, :staging


# --------------
# Roles
role :app,      "scprdev.org"
role :web,      "scprdev.org"
role :workers,  "scprdev.org"
role :db,       "scprdev.org", :primary => true
role :sphinx,   "scprdev.org"


# --------------
# Callbacks
after "deploy:update_code", "dbsync:pull"
after "deploy:update_code", "thinking_sphinx:staging:index"


# --------------
# Tasks

namespace :thinking_sphinx do
  namespace :staging do
    task :index do
      if ts_index
#        thinking_sphinx.index
      else
        logger.info "SKIPPING thinking_sphinx:index (ts_index false)"
      end
    end
  end
end

namespace :dbsync do
  task :pull do
    if dbsync
      "*** dbsync not yet implemented"
    else
      logger.info "SKIPPING dbsync (dbsync false)"
    end
  end
end

