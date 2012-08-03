class ContentEmailController < ApplicationController
  layout "minimal"

  def new
    @message = ContentEmail.new
    @url = params[:url]
    @headline = params[:headline]
    @teaser = params[:teaser]
    
  end

  def create
    @message = ContentEmail.new(params[:message])
    
    if @message.valid?
          ContentMailer.email_content(@message).deliver
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end

end