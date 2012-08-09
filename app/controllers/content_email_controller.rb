class ContentEmailController < ApplicationController
  layout "minimal"

  def new
    # initialize email sharing form and query for content by URL to get headline and teaser
    @message = ContentEmail.new
    if !defined? @content
      @content = ContentBase.obj_by_url(params[:url])
    end
    
  end

  def create
    @message = ContentEmail.new(params[:content_email])
    
    if @message.valid?
      # Deliver the email message
      ContentMailer.email_content(@message).deliver
    else
      # Didn't validate; let's return the user back to the form
      flash.alert = "Please fill out all fields."
      @content = ContentBase.obj_by_url(@message.url)
      render :new
    end
  end

end