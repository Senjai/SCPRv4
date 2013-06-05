class RemoteArticle < ActiveRecord::Base
  # This is a pseudo-abstract class (I made that term up) to act
  # as a parent class for the API adapters with which we want to 
  # be able to import content from other sources.
  #
  # An adapter MUST:
  # * Inherit from RemoteArticle
  # * Define a class method `sync`, which returns an array of 
  #   RemoteArticles. This method is meant to sync the RemoteArticles
  #   database with that adapter's API.
  # * Define an instance method `import`. This method is meant to 
  #   define how a remote article is imported into a native type.
  #   This method must accept an options hash.
  #
  # An adapter SHOULD:
  # * Define ORGANIZATION, the name of the remote source.
  
  include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
  include Outpost::Model::Identifier
  include Outpost::Model::Naming
  logs_as_task
  
  ADAPTERS = [
    "NprArticle",
    "ChrArticle"
  ]

  #---------------
  # Sphinx
  define_index do
    indexes headline
    indexes teaser
    indexes article_id
    indexes type

    has published_at
  end
  
  #---------------

  class << self
    include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation

    def types_select_collection
      RemoteArticle.select("distinct type").order("type")
        .map { |a| [a.type.constantize::ORGANIZATION, a.type] }
    end

    #---------------
    # Since this class isn't getting (and, for the
    # most part, doesn't need) the Outpost
    # Routing, we'll just manually put this one here.
    def admin_index_path
      @admin_index_path ||= Rails.application.routes.url_helpers.send("outpost_#{self.route_key}_path")
    end
    
    #---------------
    # Strip out unwanted stuff from the text.
    def process_text(text, options={})
      fragment = Nokogiri::XML::DocumentFragment.parse(text)

      Array(options[:css_to_remove]).each do |css|
        fragment.css(css).remove
      end

      Array(options[:properties_to_remove]).each do |property|
        fragment.xpath(".//@#{property}").remove
      end

      fragment.to_html
    end
    
    #---------------
    # Sync with the APIs
    def sync
      added = []
      ADAPTERS.each { |a| added += a.constantize.sync }
      added
    end

    add_transaction_tracer :sync, category: :task
  end

  #---------------

  def as_json(*args)
    super.merge({
      "id"         => self.obj_key, 
      "obj_key"    => self.obj_key,
      "to_title"   => self.to_title,
    })
  end
  
  #---------------
  
  def async_import(options={})
    import_to_class = options[:import_to_class]
    Resque.enqueue(Job::ImportRemoteArticle, self.id, import_to_class)
  end
end
