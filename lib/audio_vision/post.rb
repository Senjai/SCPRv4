module AudioVision
  class Post < Base

    class << self
      def api_path
        @api_path ||= "posts"
      end

      #-----------------

      def find_by_url(url)
        response = client.get(api_path + "/by_url", url: url)
        
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
      @byline       = attributes["byline"]
      @attributions = attributes["attributions"]
      @permalink    = attributes["permalink"]
      @published_at = Time.parse(attributes["published_at"].to_s)

      @assets = []

      Array(attributes["assets"]).each do |json|
        @assets << Asset.new(json)
      end
    end
    
  end
end
