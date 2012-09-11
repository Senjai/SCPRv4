module MultiAmerican
  class Document
    
    class << self
      def cache_key
        [MultiAmerican.cache_namespace, self.cache_namespace].join(":")
      end
      
      def cache_namespace
        "doc"
      end
      
      attr_writer :cached
      def cached
        Rails.logger.info("*** Getting document...")
        @cached ||= YAML.load(MultiAmerican.rcache.get(self.cache_key).to_s)
      end
    end
    
    attr_reader :title, :pubDate, :url
    
    def initialize(file)
      doc      = Nokogiri::XML::Document.parse(open(file))
      @url     = doc.url
      @title   = doc.at_xpath("/rss/channel/title").content
      @pubDate = doc.at_xpath("/rss/channel/pubDate").content
      
      # Eager-load all classes
      MultiAmerican.resources.each do |resource|
        instance_variable_set("@#{resource}", ["MultiAmerican", resource.to_s.singularize.camelize].join("::").constantize.find(doc))
      end
      
      # Write to cache
      MultiAmerican.rcache.set self.class.cache_key, self.to_yaml
    end

    def method_missing(method, *args, &block)
      if MultiAmerican.resources.include? method.to_s
        Rails.logger.info("*** Getting #{method}")
        instance_variable_get("@#{method}") || ["MultiAmerican", method.to_s.singularize.camelize].join("::").constantize.find
      else
        super
      end
    end
  end
end
