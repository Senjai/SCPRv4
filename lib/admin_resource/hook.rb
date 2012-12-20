##
# AdminResource::Hook
#
# Hook into Newsroom.js
#
module AdminResource
  class Hook
    attr_accessor :data, :path
    
    def initialize(options={})
      @path = options[:path]
      @data = options[:data] || { touch: true }
    end
    
    #--------------
    # Publish the message
    def publish
      Net::HTTP.post_form(URI.parse(url), data)
    end

    #--------------
    
    def url
      File.join(Rails.application.config.node.server, self.path)
    end
  end
end
