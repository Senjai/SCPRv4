##
# Index
#
# Perform sphinx indexing asynchronously
#
module Job
  class Index < Base
    @queue = "#{namespace}:sphinx"

    def self.perform(models)
      Indexer.new(*models.map(&:constantize)).index
      self.log "Successfully indexed: #{models.present? ? models : "all"}"
    end
  end
end
