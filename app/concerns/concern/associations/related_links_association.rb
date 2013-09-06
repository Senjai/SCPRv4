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
        has_many :related_links,
          :as               => :content,
          :dependent        => :destroy

        tracks_association :related_links

        accepts_nested_attributes_for :related_links,
          :allow_destroy => true,
          :reject_if     => :should_reject_related_links?
      end


      def get_link(type)
        link = self.related_links.find { |l| l.link_type == type }
        link.try(:url)
      end


      private

      def should_reject_related_links?(attributes)
        attributes['title'].blank? &&
        attributes['url'].blank?
      end
    end # RelatedLinksAssociation
  end # Associations
end # Concern
