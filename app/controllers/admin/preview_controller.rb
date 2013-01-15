class Admin::PreviewController < ApplicationController
  before_filter :set_preview
  
  respond_to :json
  
  def preview
    @content = ContentBase.obj_by_key!(params[:obj_key])
    @content.attributes.merge!(params[ActiveModel::Naming.param_key(@content.class)])
  end

  #------------------
  
  protected
  
  def set_preview
    @PREVIEW = true
  end
end
