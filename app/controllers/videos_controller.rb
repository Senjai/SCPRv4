class VideosController < ApplicationController
  layout "video"
  
  def index
    # This is going to handle the pop-up
    @video_shells = VideoShell.order("published_at desc").limit(10)
    render layout: false # last
  end
  
  def show
    # This is the main video page
    begin
      @video = params[:id] ? VideoShell.find(params[:id]) : VideoShell.order("published_at desc").last
      @asset = Asset.find(@video.assets.first.asset_id)
    rescue ActiveRecord::RecordNotFound
      redirect_to videos_path
    end
  end
  
end
