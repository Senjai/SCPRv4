module AdminResource
  module Helpers
    module Model
      if !defined?(TITLE_ATTRIBUTES)
        TITLE_ATTRIBUTES = [:name, :short_headline, :title, :headline]
      end
      
      # Convert any AR object into a human-readable title
      # Tries the attributes in TITLE_ATTRIBUTES
      # And falls back to "BlogEntry #99"
      #
      # This allows us to get a human-readable title regardless
      # of what an object's "title" attribute happens to be.
      #
      # To define your own set of attributes, do so in an initializer:
      #
      #   AdminResource::Helpers::Model::TITLE_ATTRIBUTES = [:title, :full_name]
      #
      # Usage:
      #
      #   story = NewsStory.last #=> NewsStory(id: 900, title: "Cool Story, Bro")
      #   blog  = Blog.last      #=> Blog(id: 5, name: "Some Blog")
      #   photo = Photo.last     #=> Photo(id: 10, url: "http://photos.com/kitty")
      #
      #   story.to_title  #=> "Cool Story, Bro"
      #   blog.to_title   #=> "Some Blog"
      #   photo.to_title  #=> "Photo #10"
      #
      def to_title
        title_method = TITLE_ATTRIBUTES.find { |a| self.respond_to?(a) }
        title_method ? self.send(title_method) : "#{self.class.name.titleize} ##{self.id}"
      end      
    end
  end
end
