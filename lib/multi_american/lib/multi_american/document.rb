module WP
  class Document
    attr_reader :title, :pubDate, :doc
    delegate :url, to: :doc
    
    def initialize(file)
      Rails.logger.info "*** Initialized document with #{file}"
      
      @doc = Nokogiri::XML::Document.parse(open(file))
      @title = @doc.at_xpath("/rss/channel/title").content
      @pubDate = @doc.at_xpath("/rss/channel/pubDate").content
      
      # Eager-load all classes
      WP::RESOURCES.each do |resource|
        instance_variable_set("@#{resource}", ["WP", resource.to_s.singularize.camelize].join("::").constantize.find(@doc))
      end
    end

    def method_missing(method, *args, &block)
      if WP::RESOURCES.include? method.to_s
        Rails.logger.info "*** Got #{method}"
        instance_variable_get("@#{method}")
      else
        super
      end
    end
  end
end
