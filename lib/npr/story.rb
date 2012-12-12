##
# An object version of the response body
# Doesn't handle everything yet.
#
module NPR
  class Story
    
    class << self
      def find(id)
        client = NPR::Client.new(apiKey: API_KEYS["npr"]["api_key"])
        response = client.query(id: id)
        new(response["story"])
      end
    end

    #-------------------------
    
    attr_accessor :images, :audio
    attr_reader :attributes
    
    def initialize(attributes={})
      @attributes = attributes
      @images     = []
      @audio      = []
      @bylines    = []
      
      Array.wrap(@attributes["images"]).each do |image|
        self.images.push NPR::Image.new(image)
      end
      
      Array.wrap(@attributes["audio"]).each do |audio|
        self.audio.push NPR::Audio.new(audio)
      end
      
      Array.wrap(@attributes["byline"]).each do |byline|
        self.bylines.push NPR::Byline.new(byline)
      end
    end
    
    #-------------------------
    # The primary image. Looks at the "type" attribute on 
    # an image and finds any with type "primary". If none
    # are found, then return the first image of any type.
    def primary_image
      @primary_image ||= begin
        primary = self.images.find { |i| i["type"] == "primary"}
        primary || self.images.first
      end
    end

    #-------------------------
    
    def method_missing(method, *args, &block)
      @attributes[method] || super
    end
  end
end
