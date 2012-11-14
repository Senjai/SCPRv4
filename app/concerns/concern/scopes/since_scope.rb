##
# SinceScope
# Basic scope to get objects published after the passed-in date
#
# Required attributse: [:published_at]
#
module Concern
  module Scopes
    module SinceScope
      extend ActiveSupport::Concern
      
      included do
        scope :since, ->(floor) { where("published_at > ?", floor) }
      end
    end
  end
end
