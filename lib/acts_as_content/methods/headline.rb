module ActsAsContent
  module Methods
    module Headline
      def headline
        self.send(self.class.acts_as_content_options[:headline])
      end
    end
  end
end
