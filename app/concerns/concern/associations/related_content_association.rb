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
        # This should be "referrer" and "referee"
        has_many :outgoing_references, as: :content, class_name: "Related", dependent: :destroy, order: "position"
        has_many :incoming_references, as: :related, class_name: "Related", dependent: :destroy, order: "position"
        
        after_save :_destroy_incoming_references, if: -> { self.unpublishing? }
      end
      
      #-------------------------
      # Return any content which this content references, 
      # or which is referencing this content
      def related_content
        content = []
        
        # Outgoing references: Where `content` is this object
        # So we want to grab `related`
        self.outgoing_references.each do |reference|
          content.push reference.related
        end
        
        # Incoming references: Where `related` is this object
        # So we want to grab `content`
        self.incoming_references.each do |reference|
          content.push reference.content
        end
        
        # Compact to make sure no nil records get through - those would
        # be unpublished content.
        content.compact.uniq.sort_by { |c| c.published_at }.reverse
      end

      #-------------------------
      
      def related_content_json
        self.outgoing_references.map(&:simple_json).to_json
      end

      #-------------------------
      # See AssetAssociation for more information.
      def related_content_json=(json)
        return if json.empty?
        
        json = Array(JSON.parse(json)).sort_by { |c| c["position"].to_i }
        loaded_references = []
        
        json.each do |content_hash|
          content = ContentBase.obj_by_key(content_hash["id"])
          if content && content.published?
            new_reference = Related.new(
              :position => content_hash["position"].to_i,
              :related  => content,
              :content  => self
            )
            
            loaded_references.push new_reference
          end
        end

        self.outgoing_references = loaded_references
      end


      private

      def _destroy_incoming_references
        self.incoming_references.clear
      end
    end # RelatedContentAssociation
  end # Associations
end # Concern
