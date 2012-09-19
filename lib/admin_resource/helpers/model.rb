## 
# AdminResource::Helpers::Model

module AdminResource
  module Helpers
    module Model
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Wrappers for ActiveModel::Naming
        def route_key
          @route_key ||= ActiveModel::Naming.route_key(self)
        end
        
        #--------------
        
        def singular_route_key
          @singular_route_key ||= ActiveModel::Naming.singular_route_key(self)
        end

        #--------------
        
        # This should go away eventually
        def django_admin_url
          "http://scpr.org/admin/#{self.table_name.gsub("_", "/")}"
        end

        #--------------
        
        # We're going to assume that if the table name does not use 
        # Rails conventions, then this feature was never built in Django
        def exists_in_django?
          @exists_in_django ||= self.table_name != self.name.tableize
        end
      end

      # Convert any AR object into a human-readable title
      # Tries the attributes in config.title_attributes
      # And falls back to "BlogEntry #99"
      #
      # This allows us to get a human-readable title regardless
      # of what an object's "title" attribute happens to be.
      #
      # To define your own set of attributes, do so with the config
      #
      #   AdminResource.config.title_attributes = [:title, :full_name]
      #
      # The :simple_title method will automatically be added to the array
      # and acts as the fallback.
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
      #
      
      def to_title
        attributes   = AdminResource.config.title_attributes
        title_method = attributes.find { |a| self.respond_to?(a) }
        self.send(title_method)
      end
      
      #-------------
      
      def simple_title
        class_title = self.class.name.demodulize.titleize
        
        if self.new_record?
          "New #{class_title}"
        else
          "#{class_title} ##{self.id}"
        end
      end

      #-------------
      
      # This should go away eventually
      def django_edit_url          
        [self.class.django_admin_url, self.id || "add"].join "/"
      end
      
      #-------------

      def exists_in_django?
        self.class.exists_in_django?
      end
    end
  end
end
