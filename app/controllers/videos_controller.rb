class VideosController < ApplicationController
  layout "video"
  respond_to :html, :json, :js
  
  def index
    # This is going to handle the pop-up
    @videos = VideoShell.recent_first.published.limit(9)
    respond_with @videos
  end
  
  def show
    # This is the main video page
    begin
      @video = params[:id] ? VideoShell.find(params[:id]) : @videos.first
      @asset = Asset.find(@video.assets.first.asset_id)
    rescue ActiveRecord::RecordNotFound
      redirect_to videos_path
    end
  end
  
end
