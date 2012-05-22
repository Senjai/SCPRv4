class FlatpagesController < ApplicationController  
  def show
    @flatpage = Flatpage.find(params[:id])
    layout_template = 'application'
    
    if !@flatpage.show_sidebar?
      layout_template = 'no_sidebar'
    end

    if @flatpage.render_as_template?
      layout_template = false
    end
    
    render layout: layout_template
  end
end
