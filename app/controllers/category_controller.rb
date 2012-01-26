class CategoryController < ApplicationController
  layout "content_8_4"
  
  def arts
    @category = Category.find_by_slug(params[:category])
    
    @content = ThinkingSphinx.search '',
      :classes    => ContentBase.content_classes,
      :page       => params[:page],
      :per_page   => 10,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => @category.id }   
      
    @cat_action = 'arts'
      
    render :action => 'index' 
  end

  def news
    @category = Category.find_by_slug(params[:category])
    
    @content = ThinkingSphinx.search '',
      :classes    => ContentBase.content_classes,
      :page       => params[:page],
      :per_page   => 10,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => @category.id }    
      
    @cat_action = 'news'
      
    render :action => :index
  end
  
end