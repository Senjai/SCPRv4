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
      # See AssetAssociation for more information
      def content_json=(json)
        return if json.empty?
        
        json = Array(JSON.load(json)).sort_by { |c| c["position"] }
        loaded_content = []
        
        json.each do |content_hash|
          # Make sure the content actually exists, then build the association
          if content = ContentBase.obj_by_key(content_hash["id"])
            new_content = build_content_association(content_hash, content)
            loaded_content.push new_content
          end
        end

        self.content = loaded_content
      end
    end
  end
end
