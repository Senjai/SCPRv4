class Asset
  require 'faraday'
  require 'faraday_middleware'
  
  class AssetNotFound < Faraday::Error::ClientError
    attr_reader :response
    
    def initialize(response)
      super "Asset not found."
      @response = response
    end
  end
  
  class AssetRequestError < Faraday::Error::ClientError
    attr_reader :response
    
    def initialize(response)
      super "Asset request failed with status #{response.status}"
      @response = response
    end
  end
  
  #----------
  
  class AssetErrors < Faraday::Response::Middleware
    def initialize(app)
      super(app)
    end

    def call(env)
      response = @app.call(env)
      
      response.on_complete do |env|
        if env[:status] == 404
          raise AssetNotFound, response
        elsif env[:status] == 400 || env[:status] == 500
          raise AssetRequestError, response
        end
      end
      
      response
    end
  end
  
  #----------
  
  # on class load, define our connection and middleware
  
  class << self
    @@token   = Rails.application.config.assethost.token
    @@server  = Rails.application.config.assethost.server
    @@prefix  = Rails.application.config.assethost.prefix
    
    # set up our connection at initialization time
    @@conn = Faraday.new("http://#{@@server}",:params => {:auth_token => @@token}) do |c|
      c.use Asset::AssetErrors
      c.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      c.use FaradayMiddleware::Instrumentation
      c.adapter Faraday.default_adapter
    end
    
    # -- run a request for outputs to populate convenience functions -- #
    
    resp = @@conn.get("#{@@prefix}/outputs")
    @@outputs = resp.body    
  end
    
  # asset = Asset.find(id)
  #
  # Given an asset ID, returns an asset object
  def self.find(id)
    key = "asset/asset-#{id}"
    
    if a = Rails.cache.read(key)
      # cache hit -- instantiate from the cached json
      return self.new(a)
    else
      # missed... request it from the server
      resp = @@conn.get("#{@@prefix}/assets/#{id}")

      # write this asset into cache
      Rails.cache.write(key,resp.body)
      
      # now create an asset and return it
      return self.new(resp.body)
    end
  end
  
  #----------
  
  attr_accessor :json, :caption, :title, :id, :size, :taken_at, :owner, :url, :api_url, :native
  
  def initialize(json)
    @json = json
    @_sizes = {}
    
    # Define functions for each of our output sizes.  _size will return 
    # AssetSize objects
    class << self
      @@outputs.each do |o|
        define_method o['code'] do
          self._size(o)
        end
      end
    end
    
    # define some attributes
    [:caption,:title,:id,:size,:taken_at,:owner,:url,:api_url,:native].each { |key| self.send("#{key}=",@json[key.to_s]) }
    
  end
  
  #----------
  
  def _size(output)
    @_sizes[ output['code'] ] ||= AssetSize.new(self,output)      
  end
  
  #----------
  
  def as_json(options={})
    @json
  end
end

#----------

class AssetSize
  attr_accessor  :width
  attr_accessor  :height
  attr_accessor  :tag
  attr_accessor  :url
  attr_accessor  :asset
  attr_accessor  :output
    
  def initialize(asset,output)
    @asset  = asset
    @output = output
    
    self.width    = @asset.json['sizes'][ output['code'] ]['width']
    self.height   = @asset.json['sizes'][ output['code'] ]['height']
    self.tag      = @asset.json['tags'][ output['code'] ]
    self.url      = @asset.json['urls'][ output['code'] ]

  end
  
  def tag
    @tag.html_safe
  end
end

#----------

