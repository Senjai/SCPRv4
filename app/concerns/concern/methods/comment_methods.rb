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
        API_KEYS["disqus"]["shortname"]
      end
    end # CommentMethods
  end # Methods
end # Concern
