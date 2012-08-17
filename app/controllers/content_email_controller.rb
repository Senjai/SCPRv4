class ContentEmailController < ApplicationController
  layout "minimal"

  before_filter :get_content

  def new
    # initialize email sharing form and query for content by URL to get headline and teaser
    @message = ContentEmail.new
  end

  def create
    @message = ContentEmail.new(params[:content_email])
    @message.content = @content
    
    # Check if data validates
    if @message.save
      render :create
    else
      flash.alert = "Please fill out all fields."
      render :new
    end
  end

 protected
   def get_content
       @content = ContentBase.obj_by_key(params[:obj_key])
   end
end