module AudioVision
  class Asset

    class Size
      attr_accessor :width, :height, :url

      def initialize(json={})
        @width    = json['width']
        @height   = json['height']
        @url      = json['url']
      end
    end


    #----------------------
    
    ATTRIBUTES = [
      :caption,
      :owner,
      :title
    ]
    
    SIZES = [
      :thumbnail,
      :small,
      :large,
      :full
    ]
    
    attr_accessor *(ATTRIBUTES + SIZES)

    def initialize(json={})
      @caption  = json["caption"]
      @owner    = json["owner"]
      @title    = json["title"]

      SIZES.each do |size|
        self.send("#{size}=", Asset::Size.new(json[size.to_s]))
      end
    end
  end
end
