##
# Reverse-Association with HomepageContent.
#
# For registering callbacks for deleting/unpublishing.
# Requires: [:unpublishing?]
# 
module Concern
  module Associations
    module HomepageContentAssociation
      extend ActiveSupport::Concern

      included do
        has_many :homepage_contents, as: :content, dependent: :destroy
        after_save :_destroy_homepage_contents, if: -> { self.unpublishing? }
      end


      private

      def _destroy_homepage_contents
        self.homepage_contents.clear
      end
    end
  end
end
