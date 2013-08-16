##
# CacheExpirationCallback
#
# Expires cache
# Requires the methods defined in PublishingMethods
#
# We have to set the "promises" before save so that we still have
# access to the object's dirty attributes (status). Otherwise we
# don't know if the article was just published, unpublished, or what.
#
# But we don't want to expire the cache before the record is actually
# committed to the database, because there is a small chance that the
# cache could be rewritten with the old object, before it's committed.
#
module Concern
  module Callbacks
    module CacheExpirationCallback
      extend ActiveSupport::Concern

      included do
        include Concern::Methods::PublishingMethods
        after_save :check_if_should_expire_cache
        after_commit :expire_cache
      end

      private

      def check_if_should_expire_cache
        reset_cache_promises

        # If we are going from "published" -> "published" (still),
        # or we are going from "published" -> "unpublished",
        # just expire this object
        if (self.published? && !self.publishing?) || self.unpublishing?
          @_will_expire_dependencies_on_self = true
        end

        # If we are going from "not published" -> "published".
        # Expire :new keys for the object's class and contentbase
        if self.publishing?
          @_will_expire_dependencies_on_new_objects = true
        end
      end


      def expire_cache
        if @_will_expire_dependencies_on_self
          Rails.cache.expire_obj(self)
        end

        if @_will_expire_dependencies_on_new_objects
          Rails.cache.expire_obj([self.class.content_key, "new"].join(":"))
          Rails.cache.expire_obj("contentbase:new")
        end

        reset_cache_promises
      end


      def reset_cache_promises
        @_will_expire_dependencies_on_self = nil
        @_will_expire_dependencies_on_new_objects = nil
      end
    end # CacheExpiration
  end # Callbacks
end # Concern
