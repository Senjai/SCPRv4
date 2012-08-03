class FlatpagesController < ApplicationController  
  def show
    # params[:flatpage_path] gets its slashes stripped by route globbing
    @flatpage = Flatpage.find_by_url("/#{params[:flatpage_path]}/")
    
    # Is this a redirect? Send them on their way.
    if @flatpage.redirect_url.present?
      redirect_to @flatpage.redirect_url and return
    end
        
    case @flatpage.template
    when "full"
      layout_template = 'app_nosidebar'
    when "none"
      layout_template = false
    else
      layout_template = 'application'
    end
      
    render layout: layout_template
  end
end
