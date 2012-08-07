class ContentEmailController < ApplicationController
  layout "minimal"

  def new
    @message = ContentEmail.new
    @url = params[:url]
    @headline = params[:headline]
    @teaser = params[:teaser]
    
  end

  def create
    @message = ContentEmail.new(params[:content_email])
    
    if @message.valid?
          ContentMailer.email_content(@message).deliver
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end

end