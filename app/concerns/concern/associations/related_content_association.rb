##
# RelatedContentAssociation
#
# Defines forward and backwards relations between two pieces of content.
module Concern
  module Associations
    module RelatedContentAssociation
      extend ActiveSupport::Concern
      
      included do
        # This should be "referrer" and "referee"
        has_many :outgoing_references, as: :content, class_name: "Related", dependent: :destroy, order: "position"
        has_many :incoming_references, as: :related, class_name: "Related", dependent: :destroy, order: "position"
        
        after_save :_destroy_incoming_references, if: -> { self.unpublishing? }
        accepts_json_input_for :outgoing_references
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
        content.compact.uniq
          .map(&:to_article)
          .sort { |a, b| b.public_datetime <=> a.public_datetime }
      end


      private

      def build_outgoing_reference_association(outgoing_reference_hash, content)
        if content.published?
          Related.new(
            :position => outgoing_reference_hash["position"].to_i,
            :related  => content,
            :content  => self
          )
        end
      end

      def _destroy_incoming_references
        self.incoming_references.clear
      end
    end # RelatedContentAssociation
  end # Associations
end # Concern
