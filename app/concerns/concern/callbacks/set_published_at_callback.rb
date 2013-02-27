##
# SetPublishedAtCallback
#
# Sets published_at automatically, depending on various things.
# There is no need to validate the presence of published_at because
# the two callbacks cover all possible scenarios, and the published_at
# timestamp will be automatically set if the record needs it.
# In other words, we are making it impossible for someone to 
# set a broken published_at timestamp.
#
# We need to run this before_validation because the `published?` method
# checks the in-memory object, not the persisted record. Therefore,
# something could return `true` for `#published?` but not actually be
# live on the website, eg. on a validation failure. However, if something
# is considered "published" then want to be able to assume that it has
# a valid "published_at" date, so we'll just set it ASAP.
#
# Required attributes: [:published_at, :published?]
#
# Scenarios:
# * Not publishing
#   - Do nothing
#
# * Published
#   - Set `published_at` to Time.now if `published_at` is blank
#
# * Not published
#   - Set `published_at` to nil
#     So it can be set again later when re-publishing
#
module Concern
  module Callbacks
    module SetPublishedAtCallback
      extend ActiveSupport::Concern
      
      included do
        before_validation :set_published_at_to_now, if: :should_set_published_at_to_now?
        before_validation :set_published_at_to_nil, if: :should_set_published_at_to_nil?
      end

      #--------------
      # When to set published_at to Time.now
      def should_set_published_at_to_now?
        self.published? && self.published_at.blank?
      end

      #--------------
      # When to nillify published_at
      def should_set_published_at_to_nil?
        !self.published? && self.published_at.present?
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
