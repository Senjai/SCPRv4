##
# ContentAssociation
#
# Polymorphic association to content.
# This is different from RelatedContentAssociation. This one can join
# anything to a piece of content - it's only a one-way association, 
# whereas RelatedContentAssociation is a two-way association.
#
# Adds a content_json attribute which will accept a
# JSON string of the important content attributes,
# and parses that string on save.
#
# Requires you to define a `has_many :content` association,
# and a `build_content_association` method.
#
# It also requires that the join model has defined `simple_json`.
# See HomepageContent or MissedItContent for examples.
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
        current_content_json.to_json
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

        loaded_content_json = content_to_simple_json(loaded_content)

        if current_content_json != loaded_content_json
          if self.respond_to?(:custom_changes)
            self.custom_changes['content'] = [current_content_json, loaded_content_json]
          end

          self.changed_attributes['content'] = current_content_json
          self.content = loaded_content
        end

        self.content
      end


      private

      def current_content_json
        content_to_simple_json(self.content)
      end

      def content_to_simple_json(array)
        Array(array).map(&:simple_json)
      end
    end
  end
end
