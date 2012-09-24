class PijQueriesController < ApplicationController  
  def index
    @featured  = PijQuery.visible.featured
    @evergreen = PijQuery.visible.not_featured.evergreen
    @news      = PijQuery.visible.not_featured.news
  end
  
  def show
    @query = PijQuery.visible.find_by_slug!(params[:slug])
  end
end
