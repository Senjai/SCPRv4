class PijQueriesController < ApplicationController  
  def index
    @featured     = PijQuery.published.where(is_featured: true)
    @not_featured = PijQuery.published.where(is_featured: false)
    @evergreen    = @not_featured.where(query_type: "evergreen")
    @news         = @not_featured.where(query_type: "news")
  end
  
  def show
    @query = PijQuery.published.find_by_slug!(params[:slug])
  end
end
