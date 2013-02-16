##
# CommentMethods
#
# Methods for Disqus integration
#
module Concern
  module Methods
    module CommentMethods
      def disqus_identifier
        self.obj_key
      end

      def disqus_shortname
        Rails.application.config.api["disqus"]["shortname"]
      end
    end # CommentMethods
  end # Methods
end # Concern
