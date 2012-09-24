module ActsAsContent
  module Methods
    module Body
      def body
        self.send(self.class.acts_as_content_options[:body])
      end
    end
  end
end
