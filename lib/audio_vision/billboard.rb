module AudioVision
  class Billboard < Base

    class << self
      def api_path
        @api_path ||= "billboards"
      end

      #-----------------

      def current
        response = client.get(api_path + "/current")
        
        if response.success?
          new(response.body)
        else
          nil
        end
      end
    end



    attr_accessor \
      :id,
      :layout,
      :published_at,
      :updated_at,
      :posts


    def initialize(attributes={})
      @id       = attributes["id"]
      @layout   = attributes["layout"]

      if attributes["published_at"]
        @published_at = Time.parse(attributes["published_at"].to_s)
      end

      if attributes["updated_at"]
        @updated_at = Time.parse(attributes["updated_at"].to_s)
      end

      @posts = []

      Array(attributes["posts"]).each do |json|
        @posts << AudioVision::Post.new(json)
      end
    end
  end
end
