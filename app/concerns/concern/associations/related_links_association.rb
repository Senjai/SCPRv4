##
# RelatedLinksAssociation
#
# Defines related_links and queries associations
# 
module Concern
  module Associations
    module RelatedLinksAssociation
      extend ActiveSupport::Concern
      
      included do
        has_many :related_links, as: :content, class_name: "Link", dependent: :destroy
        accepts_nested_attributes_for :related_links, allow_destroy: true, reject_if: :should_reject_related_links?
      end
      
      #----------------------
      
      private
      
      def should_reject_related_links?(attributes)
        attributes['title'].blank? &&
        attributes['link'].blank?
      end
    end # RelatedLinksAssociation
  end # Associations
end # Concern
