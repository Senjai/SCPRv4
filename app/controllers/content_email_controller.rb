class ContentEmailController < ApplicationController
  layout "minimal"

  def new
    @message = ContentEmail.new
  end

  def send

  end

end