##
# CommentMethods
#
# Methods for Disqus integration
#
module Concern
  module Methods
    module CommentMethods
      # This method needs to mimic the old obj_key behavior:
      # news/story:1234
      # The object key format was changed but disqus needs the old
      # style object keys as the identifiers.
      # It would be ideal if we could transfer all of the old ones
      # to the new ones.
      def disqus_identifier
        base = if self.class.respond_to?(:table_name)
          self.class.table_name.gsub(/_/, "/")
        else
          self.class.name.tableize
        end

        [base, self.id].join(":")
      end

      def disqus_shortname
        Rails.application.config.api["disqus"]["shortname"]
      end
    end # CommentMethods
  end # Methods
end # Concern
