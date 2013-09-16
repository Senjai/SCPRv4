##
# CommentMethods
#
# Methods for Disqus integration
#
module Concern
  module Methods
    module CommentMethods
      extend ActiveSupport::Concern

      module ClassMethods
        # This needs to be separate from `content_key`, because we changed
        # how that is getting generated (to be URL-friendly), but Disqus
        # uses the old-style obj_key to store/fetch content.
        def disqus_identifier_base
          @disqus_identifier_base
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

      def disqus_shortname
        Rails.application.config.api["disqus"]["shortname"]
      end
    end # CommentMethods
  end # Methods
end # Concern
