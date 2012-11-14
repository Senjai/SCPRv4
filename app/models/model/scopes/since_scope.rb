##
# SinceScope
# Basic scope to get objects published after the passed-in date
#
# Required attributes: [:published_at]
#
module Model
  module Scopes
    module SinceScope
      extend ActiveSupport::Concern
      
      included do
        scope :since, ->(floor) { where("published_at > ?", floor) }
      end
    end
  end
end
