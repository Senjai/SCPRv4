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
    @models     = models.reject { |e| e.blank? }
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
  # Enqueue the Index task.
  def enqueue
    Resque.enqueue(Job::Index, @models.map(&:name))
  end
end
