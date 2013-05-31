class RemoteArticle < ActiveRecord::Base
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
    #
    # Define UNWANTED_CSS to remove unwanted elements
    # Define UNWANTED_ATTRIBUTES to remove unwanted HTML properties.
    def process_text(text)
      fragment = Nokogiri::XML::DocumentFragment.parse(text)

      self::UNWANTED_CSS.each do |css|
        fragment.css(css).remove
      end

      self::UNWANTED_ATTRIBUTES.each do |attribute|
        fragment.xpath(".//@#{attribute}").remove
      end

      fragment.to_html
    end
    
    #---------------
    # Sync with the APIs
    def sync
      ADAPTERS.each { |a| a.constantize.sync }
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
