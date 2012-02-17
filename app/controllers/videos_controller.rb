class VideosController < ApplicationController
  layout "video"
  
  def index
    @video = Asset.find(:all, conditions: { native: !nil })
  end
  
  def show
    @video = VideoShell.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to videos_path
  end
  
end
