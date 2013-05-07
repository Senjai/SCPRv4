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



    ATTRIBUTES = [
      :id,
      :layout,
      :published_at,
      :updated_at,
      :posts
    ]

    attr_accessor *ATTRIBUTES


    def initialize(attributes={})
      @id           = attributes["id"]
      @layout        = attributes["layout"]
      @published_at   = Time.parse(attributes["published_at"].to_s)
      @updated_at   = Time.parse(attributes["updated_at"].to_s)

      @posts = []

      Array(attributes["posts"]).each do |json|
        @posts << AudioVision::Post.new(json)
      end
    end
    
  end
end
