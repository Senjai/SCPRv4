require 'net/http'

module AdminWatcher
  class Publisher

    def self.update_viewers(args = {})
      publish('update_viewers', args[:to], args)

      rescue Exception => e
        Rails.logger.error "+++ notify: #{e.message}"
    end

  
  private
    def self.publish(action, user, data)
      url = "http://localhost:13002/watcher/#{action}/#{user}"
      res = Net::HTTP.post_form(URI.parse(URI.encode(url)), data)

      # 200 implies successfully sent.
      # There is nothing we can do if the targe user is not online(404)
      # For any other error, raise Exception
      unless ["200", "404"].include? res.code
        raise Exception.new("Error: #{res.code}")
      end
    end
  end
end