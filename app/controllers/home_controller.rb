class HomeController < ApplicationController
  def index
    @homepage = Homepage.published.first
  end
end
