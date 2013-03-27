##
# Reverse-Association with FeaturedComment.
#
# For registering callbacks for deleting/unpublishing.
# Requires: [:unpublishing?]
#
module Concern
  module Associations
    module FeaturedCommentAssociation
      extend ActiveSupport::Concern

      included do
        has_many :featured_comments, as: :content, dependent: :destroy
        after_save :_destroy_featured_comments, if: -> { self.unpublishing? }
      end


      private

      def _destroy_featured_comments
        self.featured_comments.clear
      end
    end
  end
end
