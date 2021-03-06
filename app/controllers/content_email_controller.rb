class ContentEmailController < ApplicationController
  layout "minimal"
  before_filter :get_content

  def new
    @message = ContentEmail.new
  end

  def create
    @message = ContentEmail.new(params[:content_email])
    @message.content = @content

    if @message.save
      render :success
    else
      render :new
    end
  end

  #---------------------

  private

  def get_content
    @content = Outpost.obj_by_key!(params[:obj_key])
  end
end
