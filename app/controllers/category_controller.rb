class CategoryController < ApplicationController
  layout "application"
  
  def arts
    @category = Category.find_by_slug(params[:category])
    
    @content = ThinkingSphinx.search '',
      :classes    => [NewsStory,BlogEntry,ContentShell,ShowSegment],
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
      :classes    => [NewsStory,BlogEntry,ContentShell,ShowSegment],
      :page       => params[:page],
      :per_page   => 10,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => @category.id }    
      
    @cat_action = 'news'
      
    render :action => :index
  end
  
end