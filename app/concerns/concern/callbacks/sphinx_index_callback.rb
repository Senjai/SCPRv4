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
        after_save :promise_class_index,
          :if => -> { self.changed? }

        after_destroy :promise_class_index
        after_commit :enqueue_sphinx_index_for_class
      end


      private

      def promise_class_index
        @_will_index_class = true
      end

      def reset_index_promises
        @_will_index_class = nil
      end

      # Enqueue a sphinx index for this model
      def enqueue_sphinx_index_for_class
        if @_will_index_class
          Indexer.enqueue(self.class.name)
        end

        reset_index_promises
      end
    end
  end
end
