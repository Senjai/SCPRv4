module ActsAsContent
  module Generators
    module Teaser
      #--------------------
      # Cut down body to get teaser
      def self.generate_teaser(text, length=180)
        stripped_body = ActionController::Base.helpers.strip_tags(text).gsub("&nbsp;"," ").gsub(/\r/,'')
        match = stripped_body.match(/^(.+)/)

        if !match
          return ""
        else
          first = match[1]
          if first.length < length
            return first
          else
            # try shortening this paragraph
            short = first.match /^(.{#{length}}\w*)\W/
            return short ? "#{short[1]}..." : first
          end
        end

      end # generate_teaser
    end # Teaser

  end # Generators
end