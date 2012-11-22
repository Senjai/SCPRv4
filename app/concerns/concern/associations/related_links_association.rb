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
        has_many :related_links, as: :content, class_name: "Link", conditions: "link_type != 'query'", dependent: :destroy
        has_many :queries,       as: :content, class_name: "Link", conditions: { link_type: "query" }, dependent: :destroy
      end
    end # RelatedLinksAssociation
  end # Associations
end # Concern
