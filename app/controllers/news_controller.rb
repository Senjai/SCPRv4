class NewsController < ApplicationController
  layout "story"

  def story
    @story = NewsStory.find(params[:id])
    
    if request.env['PATH_INFO'] != @story.link_path
      redirect_to @story.link_path and return
    end
    
    # otherwise, just render
  end
end
