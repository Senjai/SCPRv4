class HomeController < ApplicationController
  layout "homepage"
  
  def index
    @homepage = Homepage.published.first
  end
end
