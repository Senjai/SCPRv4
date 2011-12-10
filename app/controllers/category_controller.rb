class CategoryController < ApplicationController
  layout "homepage"
  
  def index
    @category = Category.find_by_slug(params[:category])
    
    @content = ThinkingSphinx.search '',
      :classes    => [NewsStory],
      :page       => params[:page],
      :per_page   => 15,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => @category.id }
    
    #@content = @category.content.paginate(
    #  :page => params[:page] || 1,
    #  :per_page => 15,
    #  :conditions => "status = 5"
    #)
  end
end