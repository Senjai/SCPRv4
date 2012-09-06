module ActsAsContent
  module Methods
    module PublishedAt
      def published_at_is_valid_date
        # Chronic#parse returns nil if it can't parse the date.
        # Time#parse raises an error
        Rails.logger.info self.published_at
        unless self.Chronic.parse(self.published_at)
          errors.add(:published_at, "has an invalid format. Format should be: '01/25/2012 05:30pm'")
        end
      end
    end
  end
end
