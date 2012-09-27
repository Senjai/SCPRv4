class ContentEmailController < ApplicationController
  layout "minimal"
  before_filter :get_content

  def new
    # initialize email sharing form
    @message = ContentEmail.new
  end

  def create
    @message = ContentEmail.new(params[:content_email])
    @message.content = @content

    if @message.save
      render :success
    else
      flash.alert = "Please fill out all fields."
      render :new
    end
  end

  protected
    def get_content
      @content = ContentBase.obj_by_key(params[:obj_key]) || raise_404
    end
end
