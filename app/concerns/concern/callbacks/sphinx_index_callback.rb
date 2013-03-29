##
# Enqueue a sphinx index for this model.
#
# NOTE: This module should be included *before* HomepageCachingCallback,
# so that the callbacks are registered in the correct order.
module Concern
  module Callbacks
    module SphinxIndexCallback
      extend ActiveSupport::Concern

      included do
        after_save :enqueue_sphinx_index_for_class, if: -> { self.changed? }
        after_destroy :enqueue_sphinx_index_for_class
      end

      private

      # Enqueue a sphinx index for this model
      def enqueue_sphinx_index_for_class
        Indexer.enqueue(self.class.name)
      end
    end
  end
end
