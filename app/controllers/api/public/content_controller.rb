  class Api::Public::ContentController < Api::PublicController  
  before_filter :set_classes, :sanitize_limit, :sanitize_page, :sanitize_query, only: [:index]

  #---------------------------
  
  def index
    @content = ContentBase.search(@query, {
      :classes => @classes,
      :limit   => @limit,
      :page    => @page
    })
    
    respond_with @content
  end
  
  #---------------------------
  
  def by_url
    @content = ContentBase.obj_by_url(params[:url])
    respond_with @content
  end  
  
  #---------------------------
  
  def show
    @content = ContentBaby.obj_by_key(params[:obj_key])
    respond_with @content
  end
end
