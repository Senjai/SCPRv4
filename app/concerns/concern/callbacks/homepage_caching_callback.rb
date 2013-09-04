##
# Enqueue a homepage cache.
#
# This gets run under these circumstances:
# * The object is being unpublished. Get it off the homepage.
# * The object is being published. Get it onto the homepage.
# * The object with saved and it was changed in a way that matters
#   to the homepage. This means that something was changed besides
#   the attributes in IGNORE_ATTRIBUTES.
#
# NOTE: This module should be included *after* SphinxIndexCallback,
# so that the callbacks are registered in the correct order.
module Concern
  module Callbacks
    module HomepageCachingCallback
      extend ActiveSupport::Concern

      # If the `self.changed` array contains zero or more of only
      # these attributes, then the caching won't take place.
      #
      # For example:
      #
      #   self.changed => ['body'] # Caching won't occur
      #   self.changed => ['headline', body'] # Caching won't occur
      #   self.changed => ['body', 'teaser'] # Caching will occur
      #
      # If they only changed these attributes, then the homepage
      # doesn't need to be concerned about it.
      IGNORE_ATTRIBUTES = [
        'headline', 
        'body', 
        'slug', 
        'source', 
        'news_agency', 
        'is_from_pij', 
        'extra_asset_scheme', 
        'updated_at', 
        'base', 
        'outgoing_references',
        'related_links',
        'audio'
      ]

      included do
        after_save :enqueue_homepage_cache, if: :should_enqueue_homepage_cache?
      end

      def should_enqueue_homepage_cache?
        self.unpublishing? || self.publishing? ||
          (self.published? && changed_attribute_to_trigger_homepage_cache?)
      end


      private

      # Enqueue homepage caching
      def enqueue_homepage_cache
        Resque.enqueue(Job::HomepageCache)
      end

      # Were any attributes changed that should trigger homepage caching?
      def changed_attribute_to_trigger_homepage_cache?
        (self.changes.keys - IGNORE_ATTRIBUTES).present?
      end
    end
  end
end
