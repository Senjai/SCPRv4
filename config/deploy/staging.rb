# --------------
# Variables
set :branch, "master"
set :rails_env, :scprdev
set :ts_index, true
set :dbcopy, true


# --------------
# Roles
role :app,      "scprdev.org"
role :web,      "scprdev.org"
role :workers,  "scprdev.org"
role :db,       "scprdev.org", :primary => true
role :sphinx,   "scprdev.org"
#role :dbcopy,   "66.226.4.229"


# --------------
# Callbacks
after "deploy:update_code", "db:mercer:pull"
after "deploy:update_code", "thinking_sphinx:staging:index"
after "deploy:update_code", "deploy:npm"


# --------------
# Tasks

namespace :thinking_sphinx do
  namespace :staging do
    task :index do
      if ts_index
        thinking_sphinx.index
      else
        logger.info "SKIPPING thinking_sphinx:index (ts_index false)"
      end
    end
  end
end

namespace :db do
  namespace :mercer do
    task :pull, roles: :dbcopy do
      if dbcopy
        logger.info "dbcopy not yet implemented."
      else
        logger.info "SKIPPING dbcopy (dbcopy false)"
      end
    end
  end
end
