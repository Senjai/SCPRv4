class SectionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :raise_404
  
  def show
    @section = Section.find_by_slug!(params[:slug])
    @content = @section.content
  end
end
