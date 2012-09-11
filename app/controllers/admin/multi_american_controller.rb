class Admin::MultiAmericanController < Admin::BaseController    
  before_filter :verify_resource, except: [:index, :set_doc]
  before_filter :load_doc, except: [:set_doc]
  before_filter :load_objects, except: [:index, :resource_show, :set_doc]
  before_filter :set_parse_info_flash, except: [:set_doc]
  before_filter :set_root_breadcrumb, except: [:set_doc]
  before_filter :set_result_flash_messages, only: [:resource_index, :resource_show]

  DUMP_FILE = "#{Rails.root}/lib/multi_american/XML/multiamerican_dump.xml"

  helper_method :resource_class, :resource_name, :resource_objects, :document

  @@rcache = Rails.cache.instance_variable_get(:@data)
  
  # ---------------
  # Actions
  def resource_index
    breadcrumb resource_name.titleize
    @resources = list(resource_objects, params)
    render resource_class.index_template
  end

  # ---------------
  
  def resource_show
    breadcrumb resource_name.titleize, send("admin_index_multi_american_resource_path", resource_name)
    @resource = load_object
    render resource_class.detail_template
  end
  
  
  # ---------------
  # Utility Actions
  
  # ---------------
  # POST
  def set_doc
    # Clear the cache
    @@rcache.keys("wp:*").each { |k| @@rcache.del k }
    MultiAmerican::Document.cached = nil
    
    # Set a new document
    self.document = MultiAmerican::Document.new(params[:document_path].strip)

    # Set the known url to avoid a warning
    self.known_url = self.document.url
    
    redirect_to admin_multi_american_path, notice: "Changed document to <b>#{document.url}</b>"
  end
    
  # ---------------
  # POST
  def import
    breadcrumb resource_name.titleize, send("admin_index_multi_american_resource_path", resource_name)
    
    # Queue the job
    Resque.enqueue(MultiAmerican::ResqueJob, resource_class.name, document.url, "import", params[:id], admin_user.username)
    render 'working'
  end
  
  # ---------------
  # DELETE
  def remove
    breadcrumb resource_name.titleize, send("admin_index_multi_american_resource_path", resource_name)
    
    # Queue the job
    Resque.enqueue(MultiAmerican::ResqueJob, resource_class.name, document.url, "remove", params[:id], admin_user.username)
    render 'working'
  end


  # ---------------  

  protected
    
    def set_root_breadcrumb
      breadcrumb "Multi American Import", admin_multi_american_path
    end
    
    
    # ---------------
    # Set the flash.now with some info about the parsed file
    def set_parse_info_flash
      # If the actual URL of the document and the stored URL do not match,
      # Warn the user      
      if self.known_url and document.url != self.known_url
        flash.now[:warning] = "<b>Warning!</b> The source file has unexpectedly changed to <b>#{document.url}</b><br />
          This probably means the server was restarted."

        # Set known_url to the new one
        self.known_url = self.document.url
      end
      
      flash.now[:info] = "This data was parsed from <b>#{document.url}</b>"
    end
    
    
    # ---------------
    # Set flash messages with results parsed from query string
    def set_result_flash_messages
      if @@rcache.get MultiAmerican::ResqueJob.finished_cache_key
        if params[:errors].to_i > 0
          flash.now[:alert] = "<b>Alert!</b> There #{params[:errors] == "1" ? "was" : "were"} \
          <b>#{MultiAmerican.view.pluralize(params[:errors], 'error')}</b> during the #{params[:job]} process."
        end
      
        if params[:successes].to_i > 0
          flash.now[:notice] = "<b>Success!</b> #{params[:job].capitalize} job succeeded for \
          #{MultiAmerican.view.pluralize(params[:successes], resource_name.singularize)}"
        end
        
        # Set the stat to 0 so we don't get messages again
        @@rcache.del MultiAmerican::ResqueJob.finished_cache_key
      end
    end
    
    
    # ---------------
    # Fake AR order & pagination
    def list(items, params={})
      if params[:filter].present?
        items = items.select { |i| i.imported? == (params[:filter] == "imported" ? true : false) }
      end
      
      items.sort_by { |p| p.sorter }.reverse.paginate(page: params[:page], per_page: resource_class.admin.list.per_page)
    end
    
    
    # ---------------
    # Make sure the class is one of the MultiAmerican module, or raise error
    def verify_resource
      if MultiAmerican.resources.include? params[:resource_name]
        self.resource_name  = params[:resource_name]
        self.resource_class = ["MultiAmerican", resource_name.camelize.demodulize.singularize].join("::").constantize
      else
        raise "Invalid Resource: #{MultiAmerican.resources}" and return false
      end
    end
    
    
    # ---------------
    # Accessors
    attr_accessor :resource_class, :resource_name, :resource_objects, :document
    
    # ---------------
    # Accessor for known_url
    def known_url
      @@rcache.get([MultiAmerican::Document.cache_key, "known_url"].join(":"))
    end
    
    def known_url=(url)
      @@rcache.set([MultiAmerican::Document.cache_key, "known_url"].join(":"), url)
    end


    # ---------------
    # Loaders
    def load_doc
      # If the document cache is blank,
      # Initialize a new document
      if !(self.document = MultiAmerican::Document.cached)
        self.document = MultiAmerican::Document.new(DUMP_FILE)
      end      
    end

    # ---------------
    
    def load_objects
      self.resource_objects ||= document.send(resource_name)
    end
    
    # ---------------
    
    def load_object
      cached = YAML.load(@@rcache.get([resource_class.cache_key, params[:id]].join(":")).to_s)
      if !cached
        raise ActionController::RoutingError .new("Not Found")
      end
      return cached
    end
    
    # ---------------

end
