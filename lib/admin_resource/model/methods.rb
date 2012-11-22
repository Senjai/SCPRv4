##
# AdminResource::Model::Methods
#
# A bunch of methods that help AdminResource be awesome.
#
module AdminResource
  module Model
    module Methods
      extend ActiveSupport::Concern
      
      module ClassMethods
        def to_title
          self.name.demodulize.titleize
        end

        #--------------
        
        def content_key
          if self.respond_to? :table_name
            self.table_name.gsub(/_/, "/")
          else
            self.name.tableize
          end
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
      def title_method
        @title_method ||= begin
          attributes = AdminResource.config.title_attributes
          attributes.find { |a| self.respond_to?(a) }
        end
      end
      
      #-------------
      
      def to_title
        @to_title ||= self.send(self.title_method)
      end
      
      #-------------
      
      def simple_title
        @simple_title ||= begin
          if self.new_record?
            "New #{self.class.to_title}"
          else
            "#{self.class.to_title} ##{self.id}"
          end
        end
      end

      #-------------
      # This method should be overridden
      # Don't override as_json unless you don't
      # want its baked-in goodies
      def json
        {}
      end
      
      #-------------
      # Define some defaults for as_json
      # Override `self.json` to add attributes
      # or override any of these.
      def as_json(*args)
        super.merge({
          "id"         => self.obj_key, 
          "obj_key"    => self.obj_key,
          "link_path"  => self.link_path,
          "to_title"   => self.to_title,
          "edit_path"  => self.admin_edit_path,
          "admin_path" => self.django_edit_url
        }).merge(self.json.stringify_keys!)
      end

      #-------------

      def persisted_record
        @persisted_record ||= begin
          # If this record isn't persisted, return nil
          return nil if !self.persisted?
        
          # If attributes have been changed, then fetch
          # the persisted record from the database
          # Otherwise just use self
          if self.changed_attributes.present?
            self.class.find(self.id)
          else
            self
          end
        end
      end
          
      #-------------
      # Default obj_key pattern
      def obj_key
        @obj_key ||= [self.class.content_key,self.id || "new"].join(":")
      end
      
      #-------------

      def exists_in_django?
        self.class.exists_in_django?
      end
    end # Methods
  end # Model
end # AdminResource
