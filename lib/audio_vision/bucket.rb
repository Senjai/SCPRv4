module AudioVision
  class Bucket < Base

    class << self
      def api_path
        @api_path ||= "buckets"
      end

      #-----------------

      def find_by_key(key)
        response = client.get(api_path + "/#{key}")
        
        if response.success?
          new(response.body)
        else
          nil
        end
      end
    end



    attr_accessor \
      :id,
      :title,
      :description,
      :updated_at,
      :posts


    def initialize(attributes={})
      @id           = attributes["id"]
      @title        = attributes["title"]
      @description  = attributes["description"]

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
