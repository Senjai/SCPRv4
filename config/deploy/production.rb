require 'new_relic/recipes'
require 'net/http'

# --------------
# Variables
set :branch, "master"
set :rails_env, "production"

# --------------
# Roles
web1  = "66.226.4.226"
web2  = "66.226.4.227"
web4  = "66.226.4.240"
media = "66.226.4.228"

role :app,      web1, web2, web4
role :web,      web1, web2, web4
role :workers,  media
role :db,       web2, :primary => true
role :sphinx,   media

namespace :deploy do
  desc "Restart Application"
  task :restart, roles: [:app, :workers] do
    restart_file = "#{current_release}/tmp/restart.txt"
    delay        = restart_delay.to_i

    if delay <= 0
      logger.info "Restarting application processes immediately on all servers..."
      run "touch #{restart_file}"
    else      
      logger.info "Restarting application processes on each app server in #{restart_delay} second intervals..."
      parallel(roles: [:app, :workers], pty: true, shell: false) do |session|
        # Worker processes can be restarted immediately
        session.when "in?(:workers)", "touch #{restart_file}"

        # App processes should be staggered
        find_servers(roles: [:app]).each_with_index do |server, i|
          sleep_time = i * delay

          touch_cmd   = "sleep #{sleep_time} && touch #{restart_file} && echo [`date`] Restarted application processes for #{server}"
          restart_cmd = "nohup sh -c '(#{touch_cmd}) &' 2>&1 >> #{current_release}/log/restart.log"

          session.when "server.host == '#{server.host}'", restart_cmd
        end
      end
    end
  end
  
  # --------------
  
  task :notify do
    data = {
      :token  => "droQQ2LcESKeGPzldQr7",
      :user        => `whoami`.gsub("\n", ""),
      :datetime    => Time.now.strftime("%F %T"),
      :application => application
    }
    
    url = "http://www.scpr.org/api/private/utility/notify"
    logger.info "Sending notification to #{url}"
    Net::HTTP.post_form(URI.parse(URI.encode(url)), data)
  end
end


# --------------
# Callbacks
before "deploy:update_code", "deploy:notify"
after "deploy:update_code", "thinking_sphinx:configure"
after "deploy:update", "newrelic:notice_deployment"
