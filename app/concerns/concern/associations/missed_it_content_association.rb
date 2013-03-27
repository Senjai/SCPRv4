##
# Reverse-Association with MissedItContent.
#
# For registering callbacks for deleting/unpublishing.
# Requires: [:unpublishing?]
#
module Concern
  module Associations
    module MissedItContentAssociation
      extend ActiveSupport::Concern

      included do
        has_many :missed_it_contents, as: :content, dependent: :destroy
        after_save :_destroy_missed_it_contents, if: -> { self.unpublishing? }
      end


      private

      def _destroy_missed_it_contents
        self.missed_it_contents.clear
      end
    end
  end
end
