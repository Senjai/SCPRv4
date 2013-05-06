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



    ATTRIBUTES = [
      :id, 
      :title, 
      :teaser, 
      :body,
      :published_at, 
      :thumbnail,
      :assets, 
      :category, 
      :byline, 
      :attributions, 
      :permalink
    ]

    attr_accessor *ATTRIBUTES


    def initialize(attributes={})
      @id           = attributes["id"]
      @title        = attributes["title"]
      @teaser       = attributes["teaser"]
      @body         = attributes["body"]
      @thumbnail    = attributes["thumbnail"]
      @assets       = attributes["assets"]
      @byline       = attributes["byline"]
      @attributions = attributes["attributions"]
      @permalink    = attributes["permalink"]
      @published_at = Time.parse(attributes["published_at"].to_s)
    end
  end
end
