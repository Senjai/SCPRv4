##
# PublishedScope
# 
# Select only published records (status = STATUS_LIVE),
# and order by 'published_at desc'
#
# Required attributes: [:status, :published_at]
#
module Model
  module Scopes
    module PublishedScope
      extend ActiveSupport::Concern
      
      included do
        scope :published, -> { where(status: ContentBase::STATUS_LIVE).order("published_at desc") }
      end
    end
  end
end
