##
# Hubot hooks
#
class Hubot
  class << self
    def message(options={})
      channel = options[:channel]
      message = options[:message]
      $redis.publish channel, message
    end
  end
end
