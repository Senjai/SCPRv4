class VideosController < ApplicationController
  layout "video"
  respond_to :html, :json, :js
  
  def index
    @latest_videos = VideoShell.recent_first.published.limit(4)
    begin
      @video = VideoShell.published.recent_first.first
      @asset = Asset.find(@video.assets.first.asset_id)
    rescue
      redirect_to videos_path
    end
  end
  
  def show
    begin
      @video = VideoShell.find(params[:id])
      @asset = Asset.find(@video.assets.first.asset_id)
    rescue
      redirect_to videos_path
    end
  end
  
  def list
    @videos = VideoShell.recent_first.published.paginate(page: params[:page], per_page: 9)
    respond_with @videos
  end
end
