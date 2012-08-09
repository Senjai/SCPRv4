class PijQueriesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :raise_404
  
  def index
    @evergreen  = PijQuery.evergreen.visible
    @news       = PijQuery.news.visible
  end
  
  def show
    @query = PijQuery.visible.find_by_slug!(params[:slug])
  end
end
