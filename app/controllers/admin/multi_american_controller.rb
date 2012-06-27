class Admin::MultiAmericanController < Admin::BaseController
  require 'will_paginate/array'
  
  before_filter :verify_resource, except: :index
  before_filter :load_doc
  before_filter { |c| c.send(:breadcrumb, "Multi American Import", admin_multi_american_path) }  

  # ---------------
  # Actions
  def resource_index
    breadcrumb resource_name.titleize
    @objects = @doc.send(resource_name)
    @resources = list(@objects)
    render resource_class.index_template
  end

  # ---------------
  
  def resource_show
    breadcrumb resource_name.titleize, send("admin_index_multi_american_resource_path", resource_name)
    @raw = @doc.send(resource_name)
    @resource = @raw.find { |p| p.id == params[:id] }
    render resource_class.detail_template
  end
  
  # ---------------

  def import
    # do stuff
    # redirect_to url_for([:admin, :multi_american, resou.demodulize.underscore.pluralize]), notice: "Something happened"
  end
  
  # ---------------

  def abort
    # do stuff
    # redirect_to url_for([:admin, :multi_american, params[:resource_class].demodulize.underscore.pluralize]), notice: "Something happened"
  end
  
  # ---------------
  
  
  protected
    def load_doc
      @@doc ||= WP::Document.new("#{Rails.root}/lib/multi_american/XML/full_dump.xml")
      @doc = @@doc
    end
    
    # ---------------
    
    def list(items)
      items.sort_by { |p| p.sorter }.reverse.paginate(page: params[:page], per_page: resource_class.list_per_page)
    end

    # ---------------

    def verify_resource
      if WP::RESOURCES.include? params[:resource_name]
        @resource_name = params[:resource_name]
        @resource_class = ["WP", @resource_name.camelize.demodulize.singularize].join("::").constantize
      else
        raise "Invalid Resource" and return false
      end
    end
    
    # ---------------
    
    attr_reader :resource_class, :resource_name
    helper_method :resource_class, :resource_name    
end