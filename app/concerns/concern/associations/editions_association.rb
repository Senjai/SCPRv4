module Concern
  module Associations
    # Make sure that updating this object will also touch the edition
    # for MAXIMUM CACHE EXPIRATION POWER
    module EditionsAssociation
      extend ActiveSupport::Concern

      included do
        has_many :edition_slots,
          :dependent    => :destroy,
          :as           => :item

        after_save :touch_edition_slots, if: -> { self.changed? }
      end


      private

      def touch_edition_slots
        self.edition_slots.each(&:touch)
      end
    end # EditionsAssociation
  end # Associations
end # Concern
