##
# Generate a teaser from body if it's blank.
#
module Concern
  module Callbacks
    module GenerateTeaserCallback
      extend ActiveSupport::Concern

      TARGET_LENGTH = 180

      included do
        before_validation :generate_teaser, if: :should_generate_teaser?
      end

      def should_generate_teaser?
        self.should_validate? && self.teaser.blank?
      end

      def generate_teaser
        length = TARGET_LENGTH
        stripped_body = ActionController::Base.helpers.strip_tags(self.body).gsub("&nbsp;"," ").gsub(/\r/,'')
        
        stripped_body.match(/^(.+)/) do |match|
          first_paragraph = match[1]

          if first_paragraph.length < length
            self.teaser = first_paragraph
          else
            # try shortening this paragraph
            shortened_paragraph = first_paragraph.match(/^(.{#{length}}\w*)\W/)
            self.teaser = shortened_paragraph ? "#{shortened_paragraph[1]}..." : first_paragraph
          end
        end

        self.teaser
      end
    end
  end
end
