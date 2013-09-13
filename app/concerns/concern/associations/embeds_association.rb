module Concern
  module Associations
    module EmbedsAssociation
      extend ActiveSupport::Concern

      included do
        has_many :embeds,
          :as           => :content,
          :dependent    => :destroy

        accepts_nested_attributes_for :embeds,
          :reject_if => :should_reject_embed?
      end


      private

      def should_reject_embed?(attributes)
        attributes['url'].empty?
      end
    end
  end
end
