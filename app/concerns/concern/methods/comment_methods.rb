##
# CommentMethods
#
# Methods for Disqus integration
#
module Concern
  module Methods
    module CommentMethods
      extend ActiveSupport::Concern

      # We have to explicitly tell it which classes have comments because
      # sometimes the behaviour of Rails' lazy-loading will prevent the
      # classes from being included in the obj_by_disqus_identifier lookup.
      COMMENT_CLASSES = [
        "BlogEntry",
        "NewsStory",
        "ShowSegment",
        "Event"
      ]

      def self.obj_by_disqus_identifier(identifier)
        key, id = identifier.split(":")

        if klass = COMMENT_CLASSES.map(&:constantize).find { |c|
          c.disqus_identifier_base == key
        }
          klass.find_by_id(id)
        end
      end


      module ClassMethods
        # This needs to be separate from `content_key`, because we changed
        # how that is getting generated (to be URL-friendly), but Disqus
        # uses the old-style obj_key to store/fetch content.
        def disqus_identifier_base
          @disqus_identifier_base ||= self.table_name.gsub(/_/, "/")
        end

        def disqus_identifier_base=(value)
          @disqus_identifier_base = value
        end
      end


      # This method needs to mimic the old obj_key behavior:
      # news/story:1234
      # The object key format was changed but disqus needs the old
      # style object keys as the identifiers.
      # It would be ideal if we could transfer all of the old ones
      # to the new ones.
      def disqus_identifier
        [self.class.disqus_identifier_base, self.id].join(":")
      end

      # This is an instance method because we need to be able to override
      # it at the instance level for "The Multi-American Situation" (tm).
      def disqus_shortname
        Rails.application.config.api["disqus"]["shortname"]
      end
    end # CommentMethods
  end # Methods
end # Concern
