class VideosController < ApplicationController
  layout "video"
  before_filter :get_latest_videos, only: [:index, :show]
  respond_to :html, :json, :js
  
  def index
    @video = VideoShell.published.recent_first.first
    @asset = Asset.find(@video.assets.first.asset_id) if @video
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
    @videos = VideoShell.recent_first.published
    @videos = @videos.paginate(page: params[:page], per_page: 9)
    respond_with @videos
  end
  
  protected
  def get_latest_videos
    @latest_videos = VideoShell.recent_first.published.limit(4)
  end
end
