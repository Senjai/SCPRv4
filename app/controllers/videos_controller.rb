class VideosController < ApplicationController
  layout "video"
  
  def index
    @video_shells = VideoShell.order("published_at desc").limit(10)
    @featured = @video_shells.first
  end
  
  def show
    @video_shell = VideoShell.find_by_id(params[:id])
    # @video = Asset.find(@video_shell.asset.asset_id)
    @video = Asset.find(31492)
    
    rescue
      redirect_to videos_path
  end
  
end
