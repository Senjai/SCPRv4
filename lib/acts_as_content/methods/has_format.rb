module ActsAsContent
  module Methods
    module HasFormat
      def has_format?
        self.class.acts_as_content_options[:has_format]
      end
    end
  end
end
