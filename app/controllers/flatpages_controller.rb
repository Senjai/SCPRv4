class FlatpagesController < ApplicationController  
  def show
    # params[:flatpage_path] gets its slashes stripped by route globbing
    @flatpage = Flatpage.visible.find_by_url!("/#{params[:flatpage_path]}/")
    
    # Is this a redirect? Send them on their way.
    if @flatpage.redirect_url.present?
      redirect_to @flatpage.redirect_url and return
    end
        
    layout_template = begin
      case @flatpage.template
      when "full"  then 'app_nosidebar'
      when "forum" then "forum"
      when "none"  then false
      else 'application'
      end
    end
      
    render layout: layout_template
  end
end
