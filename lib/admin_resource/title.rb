module AdminResource
  TITLE_ATTRIBS = [:name, :short_headline, :title, :headline]
  
  module Title
    def to_title
      title_method = TITLE_ATTRIBS.find { |a| self.respond_to?(a) }
      title_method ? self.send(title_method) : "#{self.class.name.titleize} ##{self.id}"
    end
  end
end
