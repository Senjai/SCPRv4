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
      # Didn't validate; let's return the user back to the form
      flash.alert = "Please fill out all fields."
      render :new
    end
  end

  protected
    def get_content
      # query for content by obj_key to get headline and teaser
      @content = ContentBase.obj_by_key(params[:obj_key])
      raise_404 if !@content
    end
end
