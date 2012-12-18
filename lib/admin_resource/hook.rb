##
# AdminResource::Hook
#
# Hook into Newsroom.js
#
module AdminResource
  class Hook
    attr_accessor :action, :user, :data
    
    def initialize(options={})
      @action = options[:action]
      @user   = options[:user]
      @data   = options[:data] || { touch: true }
    end
    
    #--------------
    # Publish the message
    def publish
      Net::HTTP.post_form(url, data)
    end

    #--------------
    
    def url
      uri = "#{Rails.application.config.node.server}/notify/#{@action}/#{@user}"
      URI.parse(uri)
    end
  end
end
