class ContentEmailController < ApplicationController
  layout "minimal"

  def new
    @message = ContentEmail.new
  end

  def send
    ContentMailer.email_content().deliver
  end

end