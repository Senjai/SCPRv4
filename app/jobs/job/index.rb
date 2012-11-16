##
# Index
#
# Perform sphinx indexing asynchronously
#
module Job
  class Index < JobBase
    @queue = "#{namespace}:sphinx"

    def self.perform(models)
      Indexer.new(*models.map(&:constantize)).index
      self.log "Successfully indexed: #{models}"
    end
  end
end
