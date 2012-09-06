module ActsAsContent
  module Methods
    module ShortHeadline
      def short_headline
        if !self.respond_to? :headline
          raise "short_headline needs headline. Missing from #{self.class.name}."
        end

        if self[:short_headline].present?
          self[:short_headline]
        else
          self.headline
        end
      end
    end
  end
end
