class VideoController < ApplicationController
  layout "video"
  respond_to :html, :js
  
  def index
    begin
      @video = VideoShell.published.first
      get_latest_videos
    rescue
      redirect_to home_path
    end
  end
  
  def show
    begin
      @video = VideoShell.find(params[:id])
      get_latest_videos
    rescue
      redirect_to video_index_path
    end
  end
  
  def list
    @videos = VideoShell.published
    @videos = @videos.paginate(page: params[:page], per_page: 9)
    respond_with @videos
  end
  
  protected
  def get_latest_videos
    @latest_videos = VideoShell.published.limit(4)
    @latest_videos = @latest_videos.where("id != ?", @video.id) if @video.present?
  end
end
