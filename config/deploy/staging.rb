set :branch, "master"
set :rails_env, :scprdev

role :app,      "scprdev.org"
role :web,      "scprdev.org"
role :workers,  "scprdev.org"
role :db,       "scprdev.org", :primary => true
role :sphinx,   "scprdev.org"

after "deploy:update_code", "thinking_sphinx:index"
