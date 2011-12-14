class NewsController < ApplicationController
  layout "story"

  def index
    # build list of news categories    
    @content = ThinkingSphinx.search(
      '',
      :classes    => [NewsStory],
      :page       => params[:page] || 1,
      :per_page   => 12,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with => { :category => Category.where(:is_news => true).all.map { |c| c.id } }
    )
    
    render :layout => "application"
    
  end

  def story
    @story = NewsStory.find(params[:id])
    
    if request.env['PATH_INFO'] != @story.link_path
      redirect_to @story.link_path and return
    end
    
    # otherwise, just render
  end
end
