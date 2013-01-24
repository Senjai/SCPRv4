##
# SetPublishedAtCallback
#
# Sets published_at depending on various things
# Required attributes: [:published_at, :publishing?, :unpublishing?]
#
# Note that these callbacks have to run before validation
# in order to validate slug uniqueness for `published_at`
#
# Scenarios:
# * Not publishing
#   - Do nothing
#
# * Publishing (status not published -> status published)
#   - Set `published_at` to Time.now if `published_at` is blank
#
# * Unpublishing (status published -> status not published)
#   - Set `published_at` to nil
#     So it can be set again later when re-publishing
#
module Concern
  module Callbacks
    module SetPublishedAtCallback
      extend ActiveSupport::Concern
      
      included do
        before_validation :set_published_at_to_now,   if: :should_set_published_at_to_now?
        before_validation :set_published_at_to_nil,   if: :should_set_published_at_to_nil?
      end

      #--------------
      # When to set published_at to Time.now
      def should_set_published_at_to_now?
        self.publishing? and self.published_at.blank?
      end

      #--------------
      # When to nillify published_at
      def should_set_published_at_to_nil?
        self.unpublishing?
      end
      
      #--------------
      # Set published_at to Time.now
      def set_published_at_to_now
        self.published_at = Time.now
      end

      #--------------
      # Set published_at to nil
      def set_published_at_to_nil
        self.published_at = nil
      end
    end # SetPublishedAtCallback
  end # Callbacks
end # Concern
