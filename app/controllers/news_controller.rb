class NewsController < ApplicationController
  layout "story"

  def story
    @story = NewsStory.find(params[:id])
  end
end
