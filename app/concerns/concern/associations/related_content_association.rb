##
# RelatedContentAssociation
#
# Defines forward and backwards relations
# 
module Concern
  module Associations
    module RelatedContentAssociation
      extend ActiveSupport::Concern
      
      included do
        has_many :outgoing_references, as: :content, class_name: "Related", dependent: :destroy, order: "position"
        has_many :incoming_references, as: :related, class_name: "Related", dependent: :destroy, order: "position"
        
        attr_accessor :content_json
        before_save :parse_content_json
      end
      
      #-------------------------
      # Return any content which this content references, 
      # or which is referencing this content
      def related_content
        content = []
        
        self.outgoing_references.each do |reference|
          content.push reference.related
        end
        
        self.incoming_references.each do |reference|
          content.push reference.content
        end
        
        content.compact.uniq.sort_by { |c| c.published_at }.reverse
      end
      
      #-------------------------

      def parse_content_json
        # If content_json is blank, then that means we
        # didn't make any updates. Return and move on.
        return if self.content_json.blank?
        @_loaded_content = []

        Array(JSON.load(self.content_json)).each do |content_hash|
          if related = ContentBase.obj_by_key(content_hash["id"])
            association = Related.new(position: content_hash["position"], content: self, related: related)
            @_loaded_content.push association
          end
        end

        self.outgoing_references = @_loaded_content
        true
      end
    end # RelatedContentAssociation
  end # Associations
end # Concern
