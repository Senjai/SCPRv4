module ActsAsContent
  module Methods
    module Teaser
      def teaser
        if !self.respond_to? :body
          raise "teaser needs body. Missing from #{self.class.name}."
        end

        # If teaser column is present, use it
        # Otherwise try to generate the teaser from the body
        if self[:teaser].present?
          self[:teaser]
        else
          Generators::Teaser.generate_teaser(self.body)
        end
      end
    end
  end
end
