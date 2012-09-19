class Asset
  require 'faraday'
  require 'faraday_middleware'
  
  BAD_STATUS = [400, 404, 500, 502]
  
  #-------------------
  
  def self.config
    @config ||= Rails.application.config.assethost
  end
  
  #-------------------
  
  def self.outputs
    @outputs ||= begin
      key = "assets/outputs"

      # If the outputs are stored in cache, use those
      if cached = Rails.cache.read(key)
        return cached
      end
      
      # Otherwise make a request
      resp = self.connection.get("#{config.prefix}/outputs")
      
      if BAD_STATUS.include? resp.status
        # A last-resort fallback - assethost not responding and outputs not in cache
        # Should we just use this every time?
        outputs = JSON.load(File.read(Rails.root.join("util/fixtures/assethost_outputs.json")))
      else
        outputs = resp.body
        Rails.cache.write(key, outputs)
      end
      
      outputs
    end
  end
  
  #-------------------
  
  # asset = Asset.find(id)
  # Given an asset ID, returns an asset object
  #
  def self.find(id)
    key = "asset/asset-#{id}"
    
    if a = Rails.cache.read(key)
      # cache hit -- instantiate from the cached json
      return self.new(a)
    end
    
    # missed... request it from the server
    resp = connection.get("#{config.prefix}/assets/#{id}")

    if BAD_STATUS.include? resp.status
      Asset::Fallback.log(resp.status, id)
      return Asset::Fallback.new
    else
      json = resp.body
      
      # write this asset into cache
      Rails.cache.write(key,json)
      
      # now create an asset and return it
      return self.new(json)
    end
  end
  
  def self.connection
    @connection ||= begin
      Faraday.new("http://#{config.server}", params: { auth_token: config.token }) do |c|
        c.use FaradayMiddleware::ParseJson, content_type: /\bjson$/
        c.use FaradayMiddleware::Instrumentation
        c.adapter Faraday.default_adapter
      end
    end
  end
  
  #----------

  attr_accessor :json, :caption, :title, :id, :size, :taken_at, :owner, :url, :api_url, :native, :image_file_size
  
  # Define functions for each of our output sizes.  _size will return 
  # AssetSize objects
  self.outputs.each do |o|
    define_method o['code'] do
      self._size(o)
    end
  end
  
  def initialize(json)
    @json = json
    @_sizes = {}
    
    # define some attributes
    [:caption,:title,:id,:size,:taken_at,:owner,:url,:api_url,:native, :image_file_size].each { |key| self.send("#{key}=",@json[key.to_s]) }
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
  attr_accessor  :width, :height, :tag, :url, :asset, :output
    
  def initialize(asset,output)
    @asset  = asset
    @output = output
    
    self.width  = @asset.json['sizes'][ output['code'] ]['width']
    self.height = @asset.json['sizes'][ output['code'] ]['height']
    self.tag    = @asset.json['tags'][ output['code'] ]
    self.url    = @asset.json['urls'][ output['code'] ]
  end
  
  def tag
    @tag.html_safe
  end
end

#----------

class Asset::Fallback < Asset
  def self.logger
    @logger ||= Logger.new(Rails.root.join("log/asset-fallback.log"))
  end
  
  def self.log(response, id)
    logger.info "*** [#{Time.now}] AssetHost returned #{response} for Asset ##{id}"
  end
  
  def initialize
    json = JSON.load(Rails.root.join("util/fixtures/assethost_fallback.json"))
    super(json)
  end
end
