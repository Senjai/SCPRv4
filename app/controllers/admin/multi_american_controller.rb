class Admin::MultiAmericanController < Admin::BaseController
  require 'will_paginate/array'
    
  before_filter :verify_resource, except: [:index, :set_doc]
  before_filter :load_doc, except: [:set_doc]
  before_filter :load_objects, except: [:index, :set_doc]
  before_filter :set_parse_info_flash, except: [:set_doc]
  before_filter :set_root_breadcrumb, except: [:set_doc]  

  DUMP_FILE = "#{Rails.root}/lib/multi_american/XML/full_dump.xml"

  helper_method :resource_class, :resource_name, :resource_objects, :document

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
    self.class.document = WP::Document.new(params[:document_path])
    session[:doc_url] = document.url
    redirect_to admin_multi_american_path, notice: "Changed document to <b>#{document.url}</b>"
  end
    
  # ---------------
  # POST
  def import
    # Queue the job
    Resque.enqueue(resource_class, document.url, admin_user.username)
    render 'importing'
  end
  
  # ---------------
  # DELETE
  def remove
    # do stuff
    # redirect_to url_for([:admin, :multi_american, params[:resource_class].demodulize.underscore.pluralize]), notice: "Something happened"
  end


  # ---------------  

  protected
    
    def set_root_breadcrumb
      breadcrumb "Multi American Import", admin_multi_american_path
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
    # Set the flash.now with some info about the parsed file
    def set_parse_info_flash
      if session[:doc_url]
        
        # If a new document was set, an old one was already set, 
        # and they do not match, warn the user.
        if self.class.new_doc_url and self.class.new_doc_url != session[:doc_url]
          flash.now[:warning] = "<b>Warning!</b> The source file has unexpectedly changed to <b>#{document.url}</b><br />
            This probably means the server was restarted."

          # Set session[:doc_url] to the new one
          session[:doc_url] = self.class.new_doc_url
        
          # Unset the new_doc_url
          self.class.new_doc_url = nil
        end
      else
        session[:doc_url] = document.url
      end
      
      flash.now[:info] = "This data was parsed from <b>#{document.url}</b>"
    end
    
    
    # ---------------
    # Fake AR order & pagination
    def list(items)
      items.sort_by { |p| p.sorter }.reverse.paginate(page: params[:page], per_page: resource_class.list_per_page)
    end
    
    
    # ---------------
    # Readers & Helpers for resource names    
    attr_accessor :resource_class, :resource_name
    
    # ---------------
    # Dynamic accessor for objects
    attr_reader :resource_objects
    def resource_objects=(val)
      @resource_objects = document.instance_variable_set("@#{resource_name}", val)
    end
        
    
    # ---------------
    # Convenience method for accessing class document    
    def document
      self.class.document
    end
    
    
    # ---------------
    # Accessor for document
    class << self
      attr_reader :document
      attr_accessor :new_doc_url
      
      def document=(wp_doc)
        @new_doc_url = wp_doc.url
        @document = wp_doc
      end
    end
      
    
    # ---------------
    # Loaders
    def load_doc
      self.class.document ||= WP::Document.new(DUMP_FILE)
    end

    # ---------------
    
    def load_objects
      self.resource_objects ||= document.send(resource_name)
    end
    
    # ---------------
    
    def load_object
      resource_objects.find { |p| p.id == params[:id] }
    end
    
    # ---------------

end
