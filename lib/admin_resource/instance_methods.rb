module AdminResource
  module InstanceMethods
    def to_title
      title_method = TITLE_ATTRIBS.find { |a| self.respond_to?(a) }
      title_method ? self.send(title_method) : "#{self.class.name.titleize} ##{self.id}"
    end
  end
end
