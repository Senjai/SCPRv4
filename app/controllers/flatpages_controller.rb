class FlatpagesController < ApplicationController  
  def show
    @flatpage = Flatpage.find(params[:id])
    layout_template = 'application'
    
    if !@flatpage.show_sidebar?
      layout_template = 'app_nosidebar'
    end

    if @flatpage.render_as_template?
      layout_template = false
    end
    
    render layout: layout_template
  end
end
