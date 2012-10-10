class VideoController < ApplicationController
  layout "video"
  respond_to :html, :js
  
  def index
    @video = VideoShell.published.first
    get_latest_videos
  end
  
  def show
    @video = VideoShell.find(params[:id])
    get_latest_videos
  end
  
  def list
    @videos = VideoShell.published.paginate(page: params[:page], per_page: 9)
    respond_with @videos
  end
  
  protected
  def get_latest_videos
    @latest_videos = VideoShell.published.where("id != ?", @video.try(:id)).limit(4)
  end
end
