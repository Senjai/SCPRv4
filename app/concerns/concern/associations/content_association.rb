##
# ContentAssociation
#
# Polymorphic association to content
#
# Adds a content_json attribute which will accept a
# JSON string of the important content attributes,
# and parses that string on save.
#
module Concern
  module Associations
    module ContentAssociation
      extend ActiveSupport::Concern
      
      included do
        # #content_json is a way to pass in a string representation
        # of a javascript object to the model, which will then be
        # parsed and turned into content objects in the 
        # #content_json= method.
        attr_reader :content_json
      end
      
      #-------------------

      def content_json=(json)
        # If content_json is blank, then that means we
        # didn't make any updates. Return and move on.
        return if json.blank?
        
        @_loaded_content = []

        Array(JSON.load(json)).each do |content_hash|
          if content = ContentBase.obj_by_key(content_hash["id"])
            association = self.build_content_association(content_hash, content)
            @_loaded_content.push association
          end
        end

        self.content = @_loaded_content
      end
    end
  end
end
