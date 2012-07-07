class Admin::MultiAmericanController < Admin::BaseController
  require 'will_paginate/array'
    
  before_filter :verify_resource, except: [:index, :set_doc]
  before_filter :load_doc, except: [:set_doc]
  before_filter :load_objects, except: [:index, :resource_show, :set_doc]
  before_filter :set_parse_info_flash, except: [:set_doc]
  before_filter :set_root_breadcrumb, except: [:set_doc]  

  DUMP_FILE = "#{Rails.root}/lib/multi_american/XML/full_dump.xml"

  helper_method :resource_class, :resource_name, :resource_objects, :document

  @@rcache = Rails.cache.instance_variable_get(:@data)
  
  # ---------------
  # Actions
  def resource_index
    breadcrumb resource_name.titleize
    @resources = list(resource_objects)
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
    WP::Document.cached = nil
    
    # Set a new document
    self.document = WP::Document.new(params[:document_path])

    # Set the known url to avoid a warning
    self.known_url = self.document.url
    
    redirect_to admin_multi_american_path, notice: "Changed document to <b>#{document.url}</b>"
  end
    
  # ---------------
  # POST
  def import
    breadcrumb resource_name.titleize, send("admin_index_multi_american_resource_path", resource_name)
    
    # Queue the job
    Resque.enqueue(WP::ResqueJob, resource_class.name, document.url, "import", params[:id], admin_user.username)
    render 'working'
  end
  
  # ---------------
  # DELETE
  def remove
    breadcrumb resource_name.titleize, send("admin_index_multi_american_resource_path", resource_name)
    
    # Queue the job
    Resque.enqueue(WP::ResqueJob, resource_class.name, document.url, "remove", params[:id], admin_user.username)
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
    # Fake AR order & pagination
    def list(items)
      items.sort_by { |p| p.sorter }.reverse.paginate(page: params[:page], per_page: resource_class.list_per_page)
    end
    
    
    # ---------------
    # Make sure the class is one of the WP module, or raise error
    def verify_resource
      if WP::RESOURCES.include? params[:resource_name]
        self.resource_name = params[:resource_name]
        self.resource_class = ["WP", resource_name.camelize.demodulize.singularize].join("::").constantize
      else
        raise "Invalid Resource" and return false
      end
    end
    
    
    # ---------------
    # Accessors
    attr_accessor :resource_class, :resource_name, :resource_objects, :document
    
    # ---------------
    # Accessor for known_url
    def known_url
      @@rcache.get([WP::Document.cache_key, "known_url"].join(":"))
    end
    
    def known_url=(url)
      @@rcache.set([WP::Document.cache_key, "known_url"].join(":"), url)
    end


    # ---------------
    # Loaders
    def load_doc
      # If the document cache is blank,
      # Initialize a new document
      if !(self.document = WP::Document.cached)
        self.document = WP::Document.new(DUMP_FILE)
      end      
    end

    # ---------------
    
    def load_objects
      self.resource_objects ||= document.send(resource_name)
    end
    
    # ---------------
    
    def load_object
      YAML.load(@@rcache.get([resource_class.cache_key, params[:id]].join(":")).to_s)
    end
    
    # ---------------

end
