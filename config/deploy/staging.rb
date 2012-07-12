set :branch, "master"
set :rails_env, :scprdev
set :skip_ts, false
set :skip_dbcopy, false

role :app,      "scprdev.org"
role :web,      "scprdev.org"
role :workers,  "scprdev.org"
role :db,       "scprdev.org", :primary => true
role :sphinx,   "scprdev.org"
#role :dbcopy,   "66.226.4.229"

namespace :thinking_sphinx do
  namespace :staging do
    task :index do
      if skip_ts
        logger.info "SKIPPING thinking_sphinx:index"
      else
        thinking_sphinx.index
      end
    end
  end
end

namespace :db do
  namespace :mercer do
    task :pull, roles: :dbcopy do
      # todo
    end
  end
end

#after "deploy:update_code", "db:mercer:pull"
after "deploy:update_code", "thinking_sphinx:staging:index"
after "deploy:update_code", "deploy:npm"
