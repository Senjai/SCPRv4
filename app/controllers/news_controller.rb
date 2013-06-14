class NewsController < ApplicationController
  def story
    @story = NewsStory.published.find(params[:id])
    
    if ( request.env['PATH_INFO'] =~ /\/\z/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @story.public_path
      redirect_to @story.public_path and return
    end
  end
end
