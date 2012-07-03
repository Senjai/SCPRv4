module WP
  class Document
    CACHE_KEY = "doc"
    
    class << self
      def cache_key
        [WP::CACHE_KEY, CACHE_KEY].join(":")
      end
    end
    
    attr_reader :title, :pubDate, :doc, :url    
    
    def initialize(file)
      @doc = Nokogiri::XML::Document.parse(open(file))
      @url = @doc.url
      @title = @doc.at_xpath("/rss/channel/title").content
      @pubDate = @doc.at_xpath("/rss/channel/pubDate").content
      
      # Eager-load all classes
      WP::RESOURCES.each do |resource|
        instance_variable_set("@#{resource}", ["WP", resource.to_s.singularize.camelize].join("::").constantize.find(@doc))
      end
      
      # Build the doc object and write to cache
      obj = { url: @doc.url, title: @title, pubDate: @pubDate }
      @@cache.set self.class.cache_key, obj.to_yaml
    end

    def method_missing(method, *args, &block)
      if WP::RESOURCES.include? method.to_s
        instance_variable_get("@#{method}")
      else
        super
      end
    end
  end
end
