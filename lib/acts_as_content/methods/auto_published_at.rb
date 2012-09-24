module ActsAsContent
  module Methods
    module AutoPublishedAt
      def auto_published_at
        self.class.acts_as_content_options[:auto_published_at]
      end
    end
  end
end
