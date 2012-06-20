class FlatpagesController < ApplicationController  
  def show
    # params[:flatpage_path] gets its slashes stripped by route globbing
    @flatpage = Flatpage.find_by_url("/#{params[:flatpage_path]}/")
    
    # Is this a redirect? Send them on their way.
    if @flatpage.redirect_url.present?
      redirect_to @flatpage.redirect_url and return
    end
    
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
