class PressReleasesController < ApplicationController
  def index
    @press_releases = PressRelease.order("created_at desc").page(params[:page]).per(20)
  end

  def show
    @press_release = PressRelease.where(slug: params[:slug]).first!
  end
end
