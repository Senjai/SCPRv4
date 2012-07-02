module WP
  class Document
    attr_reader :title, :pubDate, :doc, :url
    
    def initialize(file)
      @doc = Nokogiri::XML::Document.parse(open(file))
      @url = Rails.cache.write "ma:doc:url", @doc.url
      @title = Rails.cache.write "ma:doc:title", @doc.at_xpath("/rss/channel/title").content
      @pubDate = Rails.cache.write "ma:doc:pubDate", @doc.at_xpath("/rss/channel/pubDate").content
      
      # Eager-load all classes
      WP::RESOURCES.each do |resource|
        instance_variable_set("@#{resource}", ["WP", resource.to_s.singularize.camelize].join("::").constantize.find(@doc))
      end
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
