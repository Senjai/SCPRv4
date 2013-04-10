class Api::Private::ContentController < Api::PrivateController
  before_filter :set_classes, 
    :sanitize_limit, :sanitize_page, :sanitize_query, 
    :sanitize_order, :sanitize_sort_mode, :sanitize_conditions,
    only: [:index]
    
  #---------------------------
  
  def index
    @content = ContentBase.search(@query, {
      :classes   => @classes,
      :limit     => @limit,
      :page      => @page,
      :order     => @order,
      :sort_mode => @sort_mode,
      :with      => @conditions
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
    @content = Outpost.obj_by_key(params[:id])
    respond_with @content
  end
end
