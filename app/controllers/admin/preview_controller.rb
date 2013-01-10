class Admin::PreviewController < ApplicationController
  before_filter :set_preview
  
  def show
    existing = ContentBase.obj_by_key(params[:obj_key])
    attributes = existing.try(:attributes) || {}
    
    @entry = BlogEntry.new(attributes.merge(params[:blog_entry]))
    @blog = @entry.blog
    render template: '/blogs/entry', layout: "blogs"
  end

  #------------------
  
  protected
  
  def set_preview
    @PREVIEW = true
  end
end
