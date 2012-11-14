class PijQueriesController < ApplicationController  
  def index
    @featured     = PijQuery.visible.where(is_featured: true)
    @not_featured = PijQuery.visible.where(is_featured: false)
    @evergreen    = @not_featured.evergreen
    @news         = @not_featured.news
  end
  
  def show
    @query = PijQuery.visible.find_by_slug!(params[:slug])
  end
end
