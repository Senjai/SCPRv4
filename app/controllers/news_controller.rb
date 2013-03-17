class NewsController < ApplicationController
  def story
    @story = NewsStory.published.find(params[:id])
    
    if ( request.env['PATH_INFO'] =~ /\/$/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @story.link_path
      redirect_to @story.link_path and return
    end
  end
end
