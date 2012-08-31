class SectionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :raise_404
  
  respond_to :html, :xml, :rss
  
  def show
    @section = Section.find_by_slug!(params[:slug])
    @content = @section.content(page: params[:page])
    respond_with @content
  end
end
