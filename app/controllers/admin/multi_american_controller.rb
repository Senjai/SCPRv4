class Admin::MultiAmericanController < Admin::BaseController
  require 'will_paginate/array'
    
  before_filter :verify_resource, except: [:index, :set_doc]
  before_filter :load_doc, except: [:set_doc]
  before_filter :load_objects, except: [:index, :set_doc]
  before_filter :set_parse_info_flash, except: [:set_doc]
  before_filter :set_root_breadcrumb, except: [:set_doc]  

  DUMP_FILE = "#{Rails.root}/lib/multi_american/XML/full_dump.xml"

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
  
  def set_doc
    @@doc = WP::Document.new(params[:document_path])
    session[:doc_url] = @@doc.url
    redirect_to admin_multi_american_path, notice: "Changed document to <b>#{@@doc.url}</b>"
  end
    
  # ---------------

  def import
    # Setup an array to loop through
    if params[:id]
      objects = [load_object]
    else
      objects = @objects
    end
    
    # Import objects and prepare flash messages
    success, failure = []
    objects.each do |object|
      if object.import
        success.push object
      else
        failure.push object
      end
    end
    
    # Setup flash messages & send success/failure arrays to next request
    flash.merge!( notice: "Successfully imported #{pluralize "object", success.size}",
                  alert: "Failed to import #{pluralize "object", failure.size}",
                  failures: failure,
                  successes: success )
    
    # Redirect
    redirect_to url_for([:admin, :multi_american, resource_name])
  end
  
  # ---------------

  def remove
    # do stuff
    # redirect_to url_for([:admin, :multi_american, params[:resource_class].demodulize.underscore.pluralize]), notice: "Something happened"
  end
  
  # ---------------
  
  
  protected

    # ---------------  
    
    def set_root_breadcrumb
      breadcrumb "Multi American Import", admin_multi_american_path
    end
    
    
    # ---------------
    # Set the flash.now with some info about the parsed file
    def set_parse_info_flash
      if session[:doc_url]
        
        # If a new document was set, an old one was already set, 
        # and they do not match, warn the user.
        if @new_doc_url and @new_doc_url != session[:doc_url]
          flash.now[:warning] = "<b>Warning:</b> The source file has unexpectedly changed to <b>#{document.url}</b><br />
            This probably means the server was reloaded."
        
          # Unset the new_doc_url
          @new_doc_url = nil
        end
      else
        session[:doc_url] = document.url
      end
      
      flash.now[:info] = "This data was parsed from <b>#{document.url}</b>"
    end
    
    # ---------------
    # Readers & Helpers for resource names    
    attr_reader :resource_class, :resource_name
    helper_method :resource_class, :resource_name, :resource_objects, :document
    
    def document
      @@doc
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
        @resource_name = params[:resource_name]
        @resource_class = ["WP", @resource_name.camelize.demodulize.singularize].join("::").constantize
      else
        raise "Invalid Resource" and return false
      end
    end
            
    # ---------------
    # Dynamic reader for objects
    def resource_objects
      @resource_objects ||= document.instance_variable_get("@#{resource_name}")
    end

    # ---------------
  
  
  private
    
    # ---------------
    # Loaders
    def load_doc
      @@doc ||= begin
        d = WP::Document.new(DUMP_FILE)
        @new_doc_url = d.url
        d
      end
    end

    # ---------------
    
    def load_objects
      resource_objects ||= document.send(resource_name)
    end
    
    # ---------------
    
    def load_object
      resource_objects.find { |p| p.id == params[:id] }
    end
    
    
    # ---------------
    # resource_object writer
    def resource_objects=(val)
      @resource_objects = document.instance_variable_set("@#{resource_name}", val)
    end
    
end
