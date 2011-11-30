class CategoryController < ApplicationController
  layout "homepage"
  
  def index
    @category = Category.find_by_slug(params[:category])
    
    @stories = @category.stories.published.paginate(
      :page => params[:page] || 1,
      :per_page => 15
    )
  end
end