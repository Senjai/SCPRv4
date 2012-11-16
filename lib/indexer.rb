##
# Indexer
#
# Index sphinx on-the-fly using ThinkingSphinx.
# This is a light wrapper around Riddle::Controller
# Also includes hooks into Resque.
#
# Arguments: A list of model classes to index.
#
class Indexer
  attr_reader :indexes, :models
  
  def initialize(*models)
    @models     = models.compact # Remove nil elements
    @controller = ThinkingSphinx::Configuration.instance.controller
    @indexes    = @models.map(&:sphinx_index_names).flatten
    @full_index = @indexes.blank?
  end

  #--------------------
  # Index what needs to be indexed
  # If any models were passed in, only index those models.
  # If no classes passed in, run a full index.
  def index
    if @full_index
      @controller.index
    else
      @controller.index @indexes
    end
  end
  
  #--------------------
  # Enqueue the IndexJob task.
  def enqueue
    Resque.enqueue(Indexer::IndexJob, @models.map(&:name))
  end

  #--------------------
  # Indexer::IndexJob
  #
  # Perform sphinx indexing asynchronously
  #
  class IndexJob
    extend LogsAsTask
    logs_as_task
    
    @queue = "#{Rails.application.config.scpr.resque_queue}:sphinx"
    
    def self.perform(models)
      begin
        indexer = Indexer.new(*models.map(&:constantize)).index
        self.log "Successfully indexed: #{models}"
      rescue Exception => e
        self.log "Failed to index: #{models}\n#{e}"
      end
    end
  end
end
