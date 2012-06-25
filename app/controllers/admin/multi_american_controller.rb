class Admin::MultiAmericanController < Admin::BaseController
  require 'will_paginate/array'
  before_filter :load_doc
  before_filter { |c| c.send(:breadcrumb, "Multi American Import", admin_multi_american_path) }  
  
  def index    
    # Have to put this here so action_missing doesn't catch it
  end
  
  # ---------------
  # action_missing catches all
  # So we don't have to define every resource manually
  
  def action_missing(method)
    plurals = WP::RESOURCES
    singulars = plurals.map { |r| r.singularize }

    if plurals.include? method.to_s
      resource_index(method.to_s)
    elsif singulars.include? method.to_s
      resource_detail(method.to_s)
    else
      super
    end
  end
  
  protected
    def load_doc
      @@doc ||= WP::Document.new("#{Rails.root}/lib/multi_american/XML/full_dump.xml")
      @doc = @@doc
    end
    
    def list(posts)
      posts.sort_by { |p| p.sorter }.reverse.paginate(page: params[:page], per_page: 20)
    end
    
    def resource_index(resources)
      breadcrumb resources.titleize
      @raw = @doc.send(resources)
      @resources = list(@raw)
      @total = @raw.size
      render @resources.first.class.index_template
    end
    
    def resource_detail(resource)
      resources = resource.pluralize
      @raw = @doc.send(resources)
      breadcrumb resources.titleize, send("admin_multi_american_#{resources}_path")
      @resource = @raw.find { |p| p.id == params[:id] }
      render @resource.class.detail_template
    end
end