class Asset
  require 'faraday'
  require 'faraday_middleware'
  
  #----------
  
  # on class load, define our connection and middleware
  
  class << self
    @@token   = Rails.application.config.assethost.token
    @@server  = Rails.application.config.assethost.server
    @@prefix  = Rails.application.config.assethost.prefix
    
    # set up our connection at initialization time
    @@conn = Faraday.new("http://#{@@server}",:params => {:auth_token => @@token}) do |c|
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

      if [400, 404, 500].include? resp.status
        return Asset::Fallback.new
      else
        json = resp.body
        
        # write this asset into cache
        # Rails.cache.write(key,json)
        
        # now create an asset and return it
        return self.new(json)
      end
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

class Asset::Fallback < Asset
  def self.image_path(size)
    dim = %w{thumb lsquare}.include?(size) ? "square" : "rect"
    ActionView::Base.new(ActionController::Base.view_paths, {}).image_path("fallback-img-#{dim}.png")
  end

  def self.json
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
  
    json = {
      sizes: {
        "thumb"   =>{"width"=>88, "height"=>88},
        "lsquare" =>{"width"=>188, "height"=>188},
        "lead"    =>{"width"=>324,"height"=>216},
        "wide"    =>{"width"=>620,"height"=>413},
        "full"    =>{"width"=>800,"height"=>533},
        "six"     =>{"width"=>540,"height"=>360},
        "eight"   =>{"width"=>729,"height"=>486},
        "four"    =>{"width"=>525,"height"=>350},
        "three"   =>{"width"=>255,"height"=>170},
        "five"    =>{"width"=>501,"height"=>334}
      },
      urls: {},
      tags: {}
    }

    sizes = json[:sizes]
    urls  = json[:urls]
    tags  = json[:tags]
  
    sizes.each do |key, hash|
      tags[key] = "<img src=\"#{image_path(key)}\" width=\"#{hash['width']}\" height=\"#{hash['height']}\" alt=\"\" />"
      urls[key] = image_path(key)
    end

    return json
  end
  
  def initialize
    json = {
      "id"         => 0, 
      "title"      => "Asset Unavailable", 
      "caption"    => "We encountered a problem, and this asset is currently unavailable", 
      "size"       => "#{Fallback.json[:sizes]['full']['width']}x#{Fallback.json[:sizes]['full']['height']}",
      "sizes"      => Fallback.json[:sizes],
      "tags"       => Fallback.json[:tags],
      "urls"       => Fallback.json[:urls],
      "url"        => Fallback.json[:urls]['full'], 
      "created_at" => Time.now
    }
    
    super(json)
  end
end
