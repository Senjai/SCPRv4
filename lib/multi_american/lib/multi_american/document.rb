module WP
  class Document
    attr_reader :title, :pubDate, :doc
    delegate :url, to: :doc
    
    def initialize(file)
      @doc = Nokogiri::XML::Document.parse(open(file))
      @title = @doc.at_xpath("/rss/channel/title").content
      @pubDate = @doc.at_xpath("/rss/channel/pubDate").content
    end

    def method_missing(method, *args, &block)
      if WP::RESOURCES.include? method.to_s
        instance_variable_get("@#{method}") || 
          instance_variable_set("@#{method}", ["WP", method.to_s.singularize.camelize].join("::").constantize.find(@doc))
      else
        super
      end
    end
  end
end
