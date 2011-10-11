class NewsController < ApplicationController

  def story
    @story = NewsStory.find(params[:id])
  end
end
