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
      
      #-------------------
      # #content_json is a way to pass in a string representation
      # of a javascript object to the model, which will then be
      # parsed and turned into content objects in the 
      # #content_json= method.
      def content_json
        self.content.map(&:simple_json).to_json
      end

      #-------------------
      # See AssetAssociation for more information
      def content_json=(json)
        return if json.empty?
        
        json = Array(JSON.parse(json)).sort_by { |c| c["position"].to_i }
        loaded_content = []
        
        json.each do |content_hash|
          # Make sure the content actually exists, and that it's
          # published, then build the association.
          content = ContentBase.obj_by_key(content_hash["id"])
          if content && content.published?
            new_content = build_content_association(content_hash, content)
            loaded_content.push new_content
          end
        end

        self.content = loaded_content
      end
    end
  end
end
